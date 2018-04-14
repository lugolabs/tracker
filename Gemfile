# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# Bootstrap form
gem 'bootstrap_form', github: 'bootstrap-ruby/rails-bootstrap-forms'

# Webpack
gem 'webpacker', github: 'rails/webpacker'

# Exceptions
gem 'exception_notification', github: 'smartinez87/exception_notification'

# Background jobs
gem 'sidekiq'

# Authentication
gem 'clearance'

# Money
gem 'money-rails', '~> 1'

# Config
gem 'figaro'

group :test do
  # Adds support for Capybara system testing
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  # Mocking and stubbing
  gem 'mocha'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Code checks
  gem 'rubocop', require: false

  # Deployment
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-puma', require: false
end
