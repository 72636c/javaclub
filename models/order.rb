# represents an order placed with the cafe

class Order < ActiveRecord::Base

  STYLES = ["cappuccino", "flat white", "latte"]
  STRENGTHS = ["mild", "medium", "strong"]

  ValidStyle = Proc.new do |style|
    STYLES.include?(style)
  end

  ValidStrength = Proc.new do |strength|
    STRENGTHS.include?(strength)
  end

  ValidQuantity = Proc.new do |quantity|
    quantity.is_a?(Numeric) && quantity > 0
  end

  def self.valid(style, strength, quantity)
    ValidStyle.call(style) &&
    ValidStrength.call(strength) &&
    ValidQuantity.call(quantity)
  end

  def price
    # TODO: this is fantastic
    Random.rand(1..100)
  end

  def to_s
    "#{self.quantity}x #{self.strength} #{self.style} = $#{self.price}"
  end

end
