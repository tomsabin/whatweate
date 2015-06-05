class Admin
  class EventsController < Admin::AdminController
    def index
      @events = Event.most_recent
    end

    def show
      @event = find_event
    end

    def new
      @hosts = find_hosts
      @event = Event.new
    end

    def create
      @hosts = find_hosts
      @event = Event.new(event_params)
      if @event.save
        redirect_to(admin_events_url, notice: "Event successfully created")
      else
        render(:new)
      end
    end

    def edit
      @hosts = find_hosts
      @event = find_event
    end

    def update
      @hosts = find_hosts
      @event = find_event
      if @event.update(event_params)
        redirect_to(admin_event_url(@event), notice: "Event successfully updated")
      else
        render(:edit)
      end
    end

    def destroy
      @event = find_event
      if @event.present?
        @event.destroy
        redirect_to(admin_events_url, notice: "Event successfully deleted")
      else
        redirect_to(edit_admin_event_url(@event))
      end
    end

    private

    def find_event
      Event.find(params[:id])
    end

    def find_hosts
      Host.all
    end

    def event_params
      params.require(:event).permit(:host_id, :date, :title, :location, :description, :menu, :seats, :price_in_pennies, :currency)
    end
  end
end
