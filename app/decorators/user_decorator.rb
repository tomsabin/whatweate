class UserDecorator < Draper::Decorator
  delegate_all

  def date_of_birth
    date = object.date_of_birth
    date.present? ? date.strftime("#{date.day.ordinalize} %B %Y") : ""
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
