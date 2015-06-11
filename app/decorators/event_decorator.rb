class EventDecorator < Draper::Decorator
  delegate_all

  def formatted_date
    date = object.date
    time = date.strftime("%I:%M%P").sub(/^0/, '')
    "#{date.strftime("#{date.day.ordinalize} %B %Y")} #{time}"
  end
end
