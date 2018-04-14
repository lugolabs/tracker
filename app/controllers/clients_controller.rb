# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[update destroy]

  def create
    @client = client_scope.build(client_params)
    return unless @client.save
    redirect_to edit_project_path(@client.original_project), notice: 'Great! Your new client is ready to roll.'
  end

  def update
    if @client.update(client_params)
      redirect_to project_path(@client.original_project), notice: 'Well done updating that client, it was about time!'
    else
      render :create
    end
  end

  def destroy
  end

  private

  def set_client
    @client = client_scope.find(params[:id])
  end

  def client_scope
    current_user.clients
  end

  def client_params
    params.require(:client).permit(:name, :notes, :original_project)
  end
end
