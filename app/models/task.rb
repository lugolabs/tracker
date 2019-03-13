# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :slots, dependent: :destroy

  validates :name, presence: true

  scope :in_progress, -> { where(completed_at: nil) }

  def toggle_completion
    if completed_at?
      update(completed_at: nil)
    else
      update(completed_at: Time.current)
    end
  end
end
