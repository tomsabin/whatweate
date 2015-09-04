class Admin
  class EventsController < AdminController
    def index
      @pending_events = Event.pending.most_recent
      @approved_events = Event.upcoming.approved.most_recent
      @past_events = Event.past.most_recent
    end

    def show
      @event = find_event.decorate
    end

    def preview
      @event = find_event.decorate
      @event_host = @event.host
      @event_user = @event_host.user
      render layout: "admin_event_preview"
    end

    def new
      @event = Event.new
      @hosts = find_hosts
    end

    def create
      @event = Event.new(event_params)

      if @event.save
        redirect_to(admin_events_url, notice: "Event successfully created")
      else
        @hosts = find_hosts
        render(:new)
      end
    end

    def edit
      @event = find_event
      @hosts = find_hosts
    end

    def update
      @event = find_event
      if @event.update(event_params)
        redirect_to(admin_event_url(@event), notice: "Event successfully updated")
      else
        @hosts = find_hosts
        render(:edit)
      end
    end

    def approve
      @event = find_event
      if @event.approve!
        flash[:notice] = "Event successfully approved"
      else
        flash[:alert] = "Event could not be approved"
      end
      redirect_to(admin_event_url(@event))
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
      Event.friendly.find(params[:id])
    end

    def find_hosts
      Host.all
    end

    def event_params
      params.require(:event).
        permit(:host_id, :slug, :date_date, :date_time, :title, :location, :location_url, :short_description,
               :description, :menu, :seats, :price, :primary_photo, :primary_photo_cache, :state, :photos_cache, photos: [])
    end
  end
end
