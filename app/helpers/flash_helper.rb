# frozen_string_literal: true

module FlashHelper
  def render_flash
    return if flash.blank?
    content_tag :div, class: 'flash-container', id: 'container-flash' do
      flash.each do |name, msg|
        div = content_tag :div, class: alert_class_name(name) do
          concat close_btn
          concat sanitize(msg)
        end
        concat div
      end
    end
  end

  private

  def close_btn
    content_tag :button, type: 'button', class: 'close', data: { dismiss: 'alert' } do
      content_tag :span, '&times;'.html_safe
    end
  end

  def alert_class_name(name)
    name = case name
           when 'error' then 'danger'
           when 'notice' then 'success'
           else name
           end
    "alert alert-#{name} mb-5"
  end
end
