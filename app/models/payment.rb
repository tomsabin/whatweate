class Payment < ActiveRecord::Base
  belongs_to :booking

  attr_accessor :token
end
