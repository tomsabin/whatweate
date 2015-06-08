class PagesController < ApplicationController
  def home
    @events = Event.approved.most_recent
  end
end
