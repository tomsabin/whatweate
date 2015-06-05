class PagesController < ApplicationController
  def home
    @events = Event.most_recent
  end
end
