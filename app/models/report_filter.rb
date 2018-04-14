# frozen_string_literal: true

class ReportFilter
  include ActiveModel::Model

  attr_reader :interval, :period, :start_at, :end_at

  def initialize(user, params)
    @user     = user
    @interval = params[:interval] || 'This week'
    @start_at = params[:start_at] || Time.current.beginning_of_week.to_i
    @end_at   = params[:end_at] || Time.current.to_i
  end

  def report
    @user.slots.ended.includes(task: :project).between(@start_at, @end_at).to_a
  end
end
