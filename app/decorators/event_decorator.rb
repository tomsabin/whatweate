class EventDecorator < Draper::Decorator
  delegate_all

  def formatted_date_time
    "#{formatted_date} #{formatted_time}"
  end

  def formatted_date
    "#{object.date.strftime("#{object.date.day.ordinalize} %B %Y")}"
  end

  def formatted_time
    object.date.strftime("%I:%M%P").sub(/^0/, '')
  end

  def remaining_seats
    object.seats - object.bookings.size
  end
end
