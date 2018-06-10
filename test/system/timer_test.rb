# frozen_string_literal: true

require 'application_system_test_case'

class TimerTest < ApplicationSystemTestCase
  test 'showing timer' do
    Time.stubs(:current).returns(Time.utc(2018, 4, 12, 15))
    project = projects(:news)

    visit timer_index_url(as: users(:fred))

    within '#timer-days #timer-day-cont-2018-04-11' do
      # Date title
      within '#timer-day-2018-04-11' do
        assert page.has_css?('.text-bolder', text: 'Wednesday, 11 Apr')
        assert page.has_css?('#timer-day-duration-2018-04-11', text: '02:00')
        assert page.has_css?('.text-pale', text: ':00')
      end

      # Slots
      within "#timer-proj-#{project.id}-2018-04-11" do
        assert page.has_css?('.col-md-4', text: '10:00 - 12:00')

        click_link '2 News'
        slot = slots(:news_home_two)
        within "#timer-slot-#{slot.id}" do
          assert page.has_css?('.text-boldy', text: slot.task.name)
          assert page.has_css?('.inline-block', text: '11:00 - 12:00')
          assert page.has_css?('.text-boldy', text: '01:00:00')
        end
      end
    end
  end

  test 'recording time' do
    task = tasks(:news_home)
    visit timer_index_url(as: users(:fred))

    within '#app-header' do
      click_link 'What are you working on ?'
      click_link task.name

      sleep 1
      assert page.has_css?('[data-target="timer.ticker"]', text: '00:00:02')
      find('[data-target="timer.playNow"]').click

      assert page.has_css?('[data-target="timer.ticker"]', text: '00:00:00')
      within '[data-target="timer.taskName"]' do
        assert page.has_content?(task.name)
        assert page.has_css?('[style="background:#1abc9c"]')
        assert page.has_content?(task.project.name)
      end
    end

    # Slots
    today = Date.today
    within "#timer-day-#{today.to_s(:db)}" do
      assert page.has_css?('.text-bolder', text: today.to_s(:short_date))
      assert page.has_css?("#timer-day-duration-#{today.to_s(:db)}", text: '00:00')
      assert page.has_css?('.text-pale', text: ':02')
    end
  end
end
