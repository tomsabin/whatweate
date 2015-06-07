class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @guests = @event.guests.decorate
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(host: current_user.host))
    if @event.save
      redirect_to(root_url, notice: "Thanks, we will review your listing and your event will be ready soon")
    else
      render(:new)
    end
  end

  private

  def event_params
    params.require(:event).permit(:date, :title, :location, :location_url, :description, :menu, :seats, :price)
  end
end
