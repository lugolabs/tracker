# frozen_string_literal: true

require 'test_helper'

class TimerControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get timer_index_url
    assert_response :success
  end

end
