# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_tab

  def index
    @projects = project_scope.order(:name)
  end

  def show
    @client = @project.client
    @client.original_project = @project.id if @client
  end

  def new
    @project = project_scope.new
  end

  def create
    @project = project_scope.build(project_params)
    if @project.save
      redirect_to @project, notice: 'Great! Another project in the bag.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Well done updating that project, it was about time!'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'You deleted it! Probably it deserved it.'
  end

  private

  def set_project
    @project = project_scope.find(params[:id])
  end

  def project_scope
    current_user.projects
  end

  def project_params
    params.require(:project).permit(:name, :client_id, :color, :rate_cents, :rate_currency)
  end

  def set_tab
    activate_tab :projects
  end
end
