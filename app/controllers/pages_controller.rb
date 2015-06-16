class PagesController < ApplicationController
  def home
    @events = Event.upcoming.approved.most_recent.decorate
  end

  def style_guide
    render layout: false
  end
end
