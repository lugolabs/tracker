# frozen_string_literal: true

require 'test_helper'

class SlotTest < ActiveSupport::TestCase
  setup do
    @slot = slots(:news_home_one)
  end

  test "start_at_time is start_at_dt in user's time zone" do
    assert_equal @slot.start_at_dt.in_time_zone(@slot.time_zone), @slot.start_at_time
  end

  test "end_at_time is end_at_dt in user's time zone" do
    assert_equal @slot.end_at_dt.in_time_zone(@slot.time_zone), @slot.end_at_time
  end

  test 'start_at_dt parses start_at' do
    assert_equal 'April 11, 2018 11:00', @slot.start_at_dt.to_s(:long)
  end

  test 'end_at_dt parses end_at' do
    assert_equal 'April 11, 2018 12:00', @slot.end_at_dt.to_s(:long)
  end

  test 'duration checks the difference between start and end date' do
    slot = Slot.new(start_at: 3.hour.ago.to_i)
    assert_equal 10800, slot.duration

    slot.end_at = 1.hour.ago.to_i
    assert_equal 7200, slot.duration
  end

  test 'project is taken from task' do
    assert_equal @slot.task.project, @slot.project
  end

  test 'time zone is taken from user' do
    assert_equal @slot.time_zone, @slot.user.time_zone
  end
end
