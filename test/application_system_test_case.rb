# frozen_string_literal: true

require 'test_helper'
require 'capybara/poltergeist'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  driven_by :poltergeist, screen_size: [1400, 1400], options: {
    phantomjs_logger: Rails.logger, debug: false, timeout: 180
  }
end
