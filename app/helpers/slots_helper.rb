# frozen_string_literal: true

module SlotsHelper
  def grouped_tasks_options(slot)
    tasks = current_user.tasks.order(:name)
                        .group_by { |t| t.project.name }
                        .each_with_object({}) { |k, h| h[k.first] = k.last.collect { |t| [t.name, t.id] } }
    grouped_options_for_select tasks, slot.task_id
  end

  def duration_total(slots)
    return if slots.blank?
    total = slots.inject(0) { |sum, s| sum + s.duration }
    formatted_duration, hours = format_duration(total, true)
    rate = slots.first.task.project.rate
    if block_given?
      cost = format_to_money(hours, rate)
      yield formatted_duration, cost
    else
      formatted_duration
    end
  end

  def format_to_money(hours, rate)
    return if rate.blank?
    formatted = humanized_money_with_symbol(Money.new(hours * rate)).split('.')
    if formatted.size > 1
      %(#{formatted.first}<span class="text-pale">.#{formatted.second}</span>).html_safe
    else
      formatted.first
    end
  end

  def format_duration(duration, show_hours = false)
    hours     = (duration / 3600).floor || 0
    minutes   = ((duration - hours * 3600) / 60).floor || 0
    seconds   = (duration - hours * 3600 - minutes * 60).floor || 0
    hours_s   = hours.to_s.rjust(2, '0')
    minutes_s = minutes.to_s.rjust(2, '0')
    seconds_s = seconds.to_s.rjust(2, '0')

    formatted = %(#{hours_s}:#{minutes_s}<span class="text-pale">:#{seconds_s}</span>).html_safe
    if show_hours
      [formatted, (hours + minutes / 60.0).round]
    else
      formatted
    end
  end
end
