# represents an invoice from the cafe that describes an order and its associated payment

class Invoice
  
  def initialize(order, payment)
    @order = order
    @payment = payment
  end

  def to_s
    @order.to_s + ", " + @payment.to_s
  end

end
