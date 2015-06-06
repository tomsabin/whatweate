class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    @guests = @event.guests.decorate
  end
end
