class EventsController < ApplicationController
  before_action :authorise_host, only: [:new, :create]

  def show
    @event = Event.friendly.find(params[:id]).decorate
    @guests = @event.guests.decorate
    @already_booked = @event.booked?(current_user)
    @event_host = user_signed_in? && @event.host == current_user.host
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(host: current_user.host))
    @event.subscribe(EventNotifier.new)
    if @event.save
      redirect_to(root_url, notice: "Thanks, we will review your listing and your event will be ready soon")
    else
      render(:new)
    end
  end

  private

  def authorise_host
    redirect_to(action: :not_found, controller: :errors) unless current_user.host.present?
  end

  def event_params
    params.require(:event).permit(:date, :title, :location, :location_url, :description, :menu, :seats, :price)
  end
end
