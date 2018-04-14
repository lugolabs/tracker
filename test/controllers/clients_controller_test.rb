# frozen_string_literal: true

require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit' do
    get clients_edit_url
    assert_response :success
  end

  test 'should get _form' do
    get clients__form_url
    assert_response :success
  end

end
