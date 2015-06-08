class HostsController < ApplicationController
  def show
    @host = Host.friendly.find(params[:id])
    @upcoming_events = @host.events.upcoming
    @past_events = @host.events.past
  end
end
