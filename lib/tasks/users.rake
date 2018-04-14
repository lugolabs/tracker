# frozen_string_literal: true

namespace :tracker do
  namespace :users do
    desc 'Create admin'
    task create_super: :environment do
      timed do
        user = User.find_or_initialize_by(email: Figaro.env.super_user_email)
        user.first_name = 'Super'
        user.last_name = 'User'
        user.role = :super_user
        user.time_zone = 'Europe/Berlin'
        user.password = Figaro.env.super_user_password
        user.save!
      end
    end
  end
end
