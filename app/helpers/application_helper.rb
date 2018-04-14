# frozen_string_literal: true

module ApplicationHelper
  def nav_link(name, path, tab, icon)
    class_name = %i[nav-link]
    class_name << (active_tab == tab ? 'text-pink' : 'text-muted')
    link_to path, class: class_name.join(' ') do
      content_tag(:i, '', class: "#{icon} mr-2") + name
    end
  end

  def current_user_tasks
    current_user.tasks
                .includes(:project)
                .joins(:project)
                .order('projects.name')
                .group_by(&:project)
  end
end
