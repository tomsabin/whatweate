class Host < ActiveRecord::Base
  belongs_to :profile

  validates :name, presence: true

  scope :alphabetical, -> { order(name: :asc) }
end
