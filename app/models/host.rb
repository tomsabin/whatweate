class Host < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true

  scope :alphabetical, -> { order(name: :asc) }
end
