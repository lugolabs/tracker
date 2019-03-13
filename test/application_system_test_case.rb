# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
      desired_capabilities: {
        chromeOptions: {
          args: %w[headless disable-gpu],
          prefs: {
            'modifyheaders.headers.name' => 'Accept-Language',
            'modifyheaders.headers.value' => 'ja,en',
          },
        },
      },
    }

  private

  # Copy page body to a testing file for debugging on browser
  def copy_page
    File.open(Rails.root.join('public', 'testing.html'), 'wb') { |f| f << page.body }
  end
end
