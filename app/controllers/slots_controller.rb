# frozen_string_literal: true

class SlotsController < ApplicationController
  before_action :set_slot, only: %i[show edit update stop destroy]

  def show
    render partial: 'slot', locals: { slot: @slot }
  end

  def edit
    render partial: 'form', locals: { slot: @slot }
  end

  def create
    if current_slot.present? && current_slot.task_id.to_s == slot_params[:task_id]
      render_json_stop current_slot
      return
    end

    slot_scope.pending.update(end_at: Time.zone.now)

    @slot          = slot_scope.build(slot_params)
    @slot.start_at = Time.zone.now
    @slot.save
    load_daily_slots
    @project_slots.present? ? render_json_slots : render_json_stop(@slot)
  end

  def update
    @slot.updating_times = true
    if @slot.update(slot_params)
      load_daily_slots
    else
      render :edit
    end
  end

  def stop
    @slot.update(end_at: Time.zone.now)
    load_daily_slots
    render_json_slots
  end

  def destroy
    @slot.destroy
    load_daily_slots
  end

  private

  def render_json_slots
    render json: {
      day_el:         "#timer-day-#{@day.to_s(:db)}",
      slots_el:       "#timer-proj-slots-#{@project.id}-#{@day.to_s(:db)}",
      project_day_el: "#timer-proj-#{@project.id}-#{@day.to_s(:db)}",
      day_cont_el:    "#timer-day-cont-#{@day.to_s(:db)}",
      stop_url:       stop_slot_path(@slot),
      day:            render_to_string(partial: 'timer/day', locals: { day: @day, daily_slots: @daily_slots }),
      slots:          render_to_string(partial: 'slots', locals: { day: @day, project: @project,
                                                                   project_slots: @project_slots })
    }
  end

  def render_json_stop(slot)
    render json: { stop_url: stop_slot_path(slot) }
  end

  def load_daily_slots
    @day           = @slot.start_at_dt.to_date
    @daily_slots   = slot_scope.ended.on_day(@slot.start_at_dt).ordered
    @project       = @slot.project
    @project_slots = @daily_slots.by_project(@project.id)
  end

  def set_slot
    @slot = slot_scope.find(params[:id])
  end

  def slot_scope
    current_user.slots
  end

  def slot_params
    params.require(:slot).permit(:task_id, :start_at_time, :end_at_time)
  end
end
