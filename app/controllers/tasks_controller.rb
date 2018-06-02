# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def new
    @task = Task.new
    render_form
  end

  def edit
    render_form
  end

  def create
    @task = @project.tasks.new(task_params)
    @task.user = current_user
    if @task.save
      render_task
    else
      render_form
    end
  end

  def update
    if @task.update(task_params)
      render_task
    else
      render_form
    end
  end

  def destroy
    @task.destroy
    redirect_to @project, notice: %(<i class="iconly-0651-smile mr-2"></i> That's the way to do it! Less is more.)
  end

  private

  def render_form
    render partial: 'form', locals: { project: @project, task: @task }
  end

  def render_task
    render partial: 'task', locals: { task: @task }
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
