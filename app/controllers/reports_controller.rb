# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_tab

  def index
    @filter = ReportFilter.new(current_user, report_filter_params)
  end

  private

  def report_filter_params
    if params.key?(:report_filter)
      params.require(:report_filter).permit(:interval, :start_at, :end_at)
    else
      {}
    end
  end

  def set_tab
    activate_tab :reports
  end
end
