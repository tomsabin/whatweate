class BookingsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    flash[:notice] = CreateBooking.perform(event, current_user)
    redirect_to(event_url(params[:event_id]))
  end
end
