# frozen_string_literal: true

module ReportsHelper
  def each_project_for(filter)
    filter.report.group_by { |s| s.task.project }.each do |project, project_slots|
      grouped_task_slots = project_slots.group_by(&:task)
      yield project, project_slots, grouped_task_slots
    end
  end
end
