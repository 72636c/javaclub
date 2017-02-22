# represents a JavaClub invoice of an order and its associated payment

class Invoice
  
  def initialize(order, payment)
    @order = order
    @payment = payment
  end

  def to_s
    @order.to_s + ", " + @payment.to_s
  end

end
