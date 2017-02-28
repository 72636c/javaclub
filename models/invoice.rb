# represents a cafe invoice of an order and its associated payment

class Invoice < ActiveRecord::Base

  belongs_to :order
  belongs_to :payment

  def self.uuid
    SecureRandom.uuid
  end

  def to_s
    self.order.to_s + ", " + self.payment.to_s
  end

end
