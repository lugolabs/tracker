# frozen_string_literal: true

require 'test_helper'

class ManualSlotControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get manual_slot_new_url
    assert_response :success
  end

end
