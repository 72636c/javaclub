# represents the credit card details provided to pay for an order

class Payment < ActiveRecord::Base

  ValidNumber = Proc.new do |number|
    number.is_a?(Numeric) && number >= 0
  end

  ValidExpiryMonth = Proc.new do |month|
    month.is_a?(Numeric) && month.between?(1, 12)
  end

  ValidExpiryYear = Proc.new do |year|
    year.is_a?(Numeric) && year >= 1900
  end

  ValidCVV = Proc.new do |cvv|
    cvv.is_a?(Numeric) && cvv.to_s.size.between?(3, 4)
  end

  def self.valid(number, expiry_month, expiry_year, cvv)
    ValidNumber.call(number) &&
    ValidExpiryMonth.call(expiry_month) &&
    ValidExpiryYear.call(expiry_year) &&
    ValidCVV.call(cvv)
  end

  def to_s
    "paid via #{self.number}, #{self.expiry_month}/#{self.expiry_year}, #{self.cvv}"
  end

end
