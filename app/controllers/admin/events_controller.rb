class Admin::EventsController < ApplicationController
  # before_action :authenticate_admin!

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to(admin_events_url, notice: "Event successfully created")
    else
      render(:new)
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :location, :description, :menu, :seats, :price_in_pennies, :currency)
  end

end
