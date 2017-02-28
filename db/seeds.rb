order_list = []

order_list.each do |style, strength, quantity|
  Order.create(style: style, strength: strength, quantity: quantity)
end
