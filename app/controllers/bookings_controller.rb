class BookingsController < ApplicationController
  before_action :assign_event

  def create
    if @event.sold_out?
      flash[:notice] = "Sorry, this event has sold out"
    elsif @event.seated?(current_user)
      flash[:notice] = "You are already booked on this event"
    elsif user_signed_in?
      if EventBooking.make(event: @event, user: current_user)
        flash[:notice] = "Thanks! We've booked you a seat"
      else
        flash[:notice] = t("error")
      end
    else
      flash[:notice] = t("devise.failure.unauthenticated")
    end
    redirect_to(event_url(params[:event_id]))
  end

  private

  def assign_event
    @event = Event.find(params[:event_id])
  end
end
