order_list =
[
  [ "latte", "strong", 1 ],
  [ "flat white", "mild", 2 ]
]

order_list.each do |style, strength, quantity|
  Order.create(style: style, strength: strength, quantity: quantity)
end
