# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup { Time.stubs(:current).returns(Time.utc(2018, 4, 12, 15)) }

  test 'visiting the index' do
    visit reports_url(as: users(:fred))

    # Title
    assert_selector 'h1', text: 'Reports'

    # Total
    assert_selector 'h3', text: 'Total 02:00:00'
    project = projects(:news)

    within '.item-brd' do
      # Project duration
      assert_selector %(a[href="#report-slots-#{project.id}"]), text: "1 #{project.name}"
      assert_selector '.h6', text: '02:00:00'

      # Open project to view tasks
      click_link "1 #{project.name}"
    end

    # task
    within '.item-brd:last-child' do
      assert_selector 'h5', text: 'Home page feature'
      assert_selector '.h6', text: '02:00:00'
    end
  end
end
