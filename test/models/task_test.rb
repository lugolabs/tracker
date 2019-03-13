# frozen_string_literal: true

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test '#toggle_completion toggles completed_at' do
    task = tasks(:news_home)
    refute task.completed_at?

    task.toggle_completion
    assert task.reload.completed_at?

    task.toggle_completion
    refute task.reload.completed_at?
  end
end
