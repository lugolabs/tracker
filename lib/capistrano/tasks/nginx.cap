namespace :nginx do
  %w(start stop restart reload).each do |task_name|
    desc "#{task } Nginx"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "/etc/init.d/nginx #{task_name}"
      end
    end
  end
end
