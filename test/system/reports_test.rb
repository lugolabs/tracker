# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit reports_url(as: users(:fred))

    assert_selector 'h1', text: 'Reports'
  end
end
