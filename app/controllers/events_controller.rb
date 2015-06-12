class EventsController < ApplicationController
  before_action :authorise_host, only: [:new, :create]

  def show
    @event = Event.approved.friendly.find(params[:id]).decorate
    @event_host = @event.host
    @event_user = @event.host.user
    @guests = @event.guests.decorate
    @already_booked = @event.booked?(current_user)
    @current_user_is_event_host = user_signed_in? && @event.host == current_user.host
  end

  def new
    @event_thumbnail = Event.new(thumbnail_params).decorate
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
    params.require(:event).
      permit(:date, :title, :location, :location_url, :description, :menu,
             :seats, :price, :primary_photo, :primary_photo_cache, photos: [])
  end

  def thumbnail_params
    {
      title: "Event title",
      date: 1.month.from_now.change(hour: 19, min: 30),
      price_in_pennies: 3000,
      description: "Your description here"
    }
  end
end
