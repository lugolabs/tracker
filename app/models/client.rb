# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :nullify

  attr_accessor :original_project

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
