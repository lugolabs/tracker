# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :task
  belongs_to :user

  attr_accessor :updating_times, :creating_manually, :start_at_formatted
  attr_writer :start_at_time, :end_at_time

  validates :start_at, presence: true, unless: :creating_manually
  validates :start_at_time, :end_at_time, presence: true, if: :updating_times
  validates :start_at_formatted, :end_at_time, presence: true, if: :creating_manually

  before_save :set_times, :set_manual_times

  scope :pending, -> { where(end_at: nil) }
  scope :ended, -> { where.not(end_at: nil) }
  scope :recent, -> { where('start_at > ?', 1.week.ago.to_i).ordered }
  scope :ordered, -> { order(start_at: :desc) }
  scope :on_day, ->(day) { between(day.beginning_of_day.to_i, day.end_of_day.to_i) }
  scope :between, ->(start_time, end_time) { where('start_at BETWEEN ? AND ?', start_time, end_time) }
  scope :by_project, ->(project_id) { joins(:task).where(tasks: { project_id: project_id }) }

  def start_at_time
    @start_at_time || start_at_dt.in_time_zone(time_zone)
  end

  def end_at_time
    @end_at_time || end_at_dt.try(:in_time_zone, time_zone)
  end

  def start_at_dt
    Time.strptime(start_at.to_s, '%s')
  end

  def end_at_dt
    return if end_at.blank?
    Time.strptime(end_at.to_s, '%s')
  end

  def duration
    (end_at || Time.zone.now) - start_at
  end

  delegate :project, to: :task

  def time_zone
    user.try(:time_zone)
  end

  private

  def set_times
    return unless updating_times
    self.start_at = Time.zone.parse("#{start_at_dt.strftime('%Y-%m-%d')} #{start_at_time}")
    self.end_at   = Time.zone.parse("#{end_at_dt.strftime('%Y-%m-%d')} #{end_at_time}")
  end

  def set_manual_times
    return unless creating_manually
    start_at_value = Time.zone.parse(start_at_formatted.sub('T', ' '))
    self.start_at  = start_at_value
    self.end_at    = Time.zone.parse("#{start_at_value.strftime('%Y-%m-%d')} #{end_at_time}")
  end
end
