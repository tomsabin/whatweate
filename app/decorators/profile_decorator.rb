class ProfileDecorator < Draper::Decorator
  delegate_all

  def date_of_birth
    date = object.date_of_birth
    date.present? ? date.strftime("#{date.day.ordinalize} %B %Y") : ""
  end
end
