# represents an order placed with JavaClub

class Order

  TYPES = ["cappuccino", "flat white", "latte"]
  STRENGTHS = ["mild", "medium", "strong"]
  
  ValidType = Proc.new do |type|
    TYPES.include?(type)
  end

  ValidStrength = Proc.new do |strength|
    STRENGTHS.include?(strength)
  end

  ValidQuantity = Proc.new do |quantity|
    quantity.is_a?(Numeric) && quantity > 0
  end

  def self.valid(type, strength, quantity)
    ValidType.call(type) &&
    ValidStrength.call(strength) &&
    ValidQuantity.call(quantity)
  end

  def initialize(type, strength, quantity)
    @type = type
    @strength = strength
    @quantity = quantity
    @price = Random.rand(1..100)
  end

  def to_s
    "#{@quantity}x #{@strength} #{@type} = $#{@price}"
  end

end
