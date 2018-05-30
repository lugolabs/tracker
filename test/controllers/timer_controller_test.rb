# frozen_string_literal: true

require 'test_helper'

class TimerControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get timer_index_url(as: users(:fred))
    assert_response :success
    assert_select 'a.text-pink', 'Timer'
  end
end
