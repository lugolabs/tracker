# frozen_string_literal: true

require 'test_helper'

class SlotsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    slot = slots(:news_home_one)
    get slot_url(slot, as: users(:fred))

    assert_response :success
    assert_select '.text-boldy', slot.task.name
    assert_select '.text-muted', '11:00 -
        12:00'
    assert_select %(a[data-target="task"][data-action="timer#playTask"]), 'Start'
    assert_select %(a[data-replace="#timer-slot-#{slot.id}"][data-remote="true"]), 'Edit'
    assert_select %(a[href="#{slot_path(slot)}"][data-remote="true"]), 'Delete'
  end

  def copy_page
    File.open(Rails.root.join('public', 'testing.html'), 'wb') { |f| f << response.body }
  end
end
