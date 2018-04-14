# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  before_action :require_login, :set_user_time_zone, :load_current_slot

  helper_method :active_tab, :current_slot

  private

  attr_reader :active_tab, :current_slot

  def load_current_slot
    return unless signed_in?
    @current_slot = current_user.slots.pending.last
  end

  def load_recent_slots
    @recent_slots = current_user.slots.ended.recent
                                .includes(task: :project).to_a
                                .group_by { |s| s.start_at_dt.to_date }
  end

  def set_user_time_zone
    Time.zone = current_user.time_zone if signed_in?
  end

  def activate_tab(tab)
    @active_tab = tab
  end
end
