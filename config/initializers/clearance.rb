# frozen_string_literal: true

Clearance.configure do |config|
  config.mailer_sender = Figaro.env.email_sender
  config.rotate_csrf_on_sign_in = true
  config.routes = false
end
