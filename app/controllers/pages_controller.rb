class PagesController < ApplicationController
  def home
    @events = Event.upcoming.approved.most_recent
  end
end
