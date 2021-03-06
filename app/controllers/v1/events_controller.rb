class V1::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    @events = Event.where(owner: @current_user)
  end

  def show
  end

  def create
    @event = Event.create!(event_params)
    render json: @event
  end

  def update
    @event.update_attributes!(event_params)
    render json: @event
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id], owner: @current_user)
  rescue Mongoid::Errors::DocumentNotFound
    render 'shared/404', status: :not_found
  end

  def event_params
    params.permit(:name, :date, :periodicity, :owner)
  end
end
