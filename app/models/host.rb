class Host < ActiveRecord::Base
  extend FriendlyId

  belongs_to :user, inverse_of: :host
  has_many :events, dependent: :restrict_with_error

  validates :name, presence: true

  scope :alphabetical, -> { order(name: :asc) }

  friendly_id :name, use: :slugged
end
