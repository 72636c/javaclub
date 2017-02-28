# represents the credit card details provided to pay for an order

class Payment < ActiveRecord::Base

  # string requirement hopefully prevents leading zeroes from being dropped
  ValidNumber = Proc.new do |number|
    number.is_a?(String) && /^(\d)+$/ === number && number.size.between?(7, 19)
  end

  # does not guarantee data type; use Date.civil(year.to_i, month.to_i, -1) when creating a Payment
  ValidExpiry = Proc.new do |month, year|
    /^(\d)+$/ === month.to_s && month.to_i.between?(1, 12) &&
    /^(\d)+$/ === year.to_s && year.to_i.between?(Date.today.year, 9999) &&
    Date.civil(year.to_i, month.to_i, -1) >= Date.today
  end

  # string requirement hopefully prevents leading zeroes from being dropped
  ValidCVV = Proc.new do |cvv|
    cvv.is_a?(String) && /^(\d)+$/ === cvv && cvv.size.between?(3, 4)
  end

  def self.valid(number, expiry_month, expiry_year, cvv)
    ValidNumber.call(number) &&
    ValidExpiry.call(expiry_month, expiry_year) &&
    ValidCVV.call(cvv)
  end

  def to_s
    "paid via #{self.number}, #{self.expiry.month}/#{self.expiry.year}, #{self.cvv}"
  end

end
