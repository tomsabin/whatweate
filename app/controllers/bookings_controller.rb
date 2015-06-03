class BookingsController < ApplicationController
  def create
    if user_signed_in?
      flash[:notice] = Booking.create(event: event, user: current_user) ? "Thanks! We've booked you a seat" : t("error")
      redirect_to(event_url(params[:event_id]))
    else
      redirect_to(event_url(params[:event_id]), notice: t("devise.failure.unauthenticated"))
    end
  end

  private

  def event
    Event.find(params[:event_id])
  end
end
