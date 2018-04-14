# frozen_string_literal: true

class ManualSlotsController < ApplicationController
  before_action :set_tab

  def new
    @slot = Slot.new
  end

  def create
    @slot = current_user.slots.build(slot_params)
    @slot.creating_manually = true
    if @slot.save
      redirect_to timer_index_path, notice: '<i class="iconly-0651-smile"></i> Got it! New time worked created.'
    else
      render :new
    end
  end

  private

  def set_tab
    activate_tab :manual
  end

  def slot_params
    params.require(:slot).permit(:task_id, :start_at_formatted, :end_at_time)
  end
end
