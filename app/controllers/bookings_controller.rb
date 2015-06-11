class BookingsController < ApplicationController
  def create
    event = Event.friendly.find(params[:event_id])
    flash[:notice] = CreateBooking.perform(event, current_user, params[:stripeToken])
    redirect_to(event_url(params[:event_id]))
  end
end
