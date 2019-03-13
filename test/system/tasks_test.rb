# frozen_string_literal: true

require 'application_system_test_case'

class TasksTest < ApplicationSystemTestCase
  test 'can complete a task' do
    # with_js_driver do
      task = tasks(:news_home)
      project = task.project

      # Project page
      visit project_url(project, as: users(:fred))

      # Title
      assert_selector 'h1', text: project.name

      within "#project-task-#{task.id}" do
        find('[data-action="toggle"]').click
      end

      assert_selector "#project-task-#{task.id} a[data-action='toggle'].text-success"
      assert task.reload.completed_at?
    # end
  end
end
