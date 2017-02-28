# represents an order placed with the cafe

class Order < ActiveRecord::Base

  STYLES = ["cappuccino", "flat white", "latte"]
  STRENGTHS = ["mild", "medium", "strong"]

  ValidStyle = Proc.new do |style|
    style.is_a?(String) && STYLES.include?(style)
  end

  ValidStrength = Proc.new do |strength|
    strength.is_a?(String) && STRENGTHS.include?(strength)
  end

  # does not guarantee data type; use to_i when creating an Order
  ValidQuantity = Proc.new do |quantity|
    /^[+]?(\d)+$/ === quantity.to_s && quantity.to_i.between?(1, 9999)
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
