require "base64"
require "json"
require "sinatra/base"

require "./config/environment"
require "./model/Invoice"
require "./model/Order"
require "./model/Payment"

class JavaClub < Sinatra::Base

  set :show_exceptions, false

  get "/" do

    return status 406 unless request.accept?("application/json")

    meta = [
      {
        :url => "/menu",
        :methods => "GET"
      }
    ]

    {:meta => meta}.to_json

  end

  get "/menu" do

    return status 406 unless request.accept?("application/json")

    menu =
    {
      :type => Order::TYPES,
      :strength => Order::STRENGTHS
    }

    meta =
    [
      {
        :url => "/order",
        :methods => ["GET", "POST"]
      }
    ]

    {:menu => menu, :meta => meta}.to_json

  end

  get "/order" do

    return status 406 unless request.accept?("application/json")

    order =
    {
      :type => "",
      :strength => "",
      :quantity => 0
    }

    meta =
    [
      {
        :url => "/order",
        :methods => ["POST"]
      }
    ]

    {:order => order, :meta => meta}.to_json

  end

  post "/order" do

    return status 406 unless request.accept?("application/json")

    parsed_order = JSON.parse(request.body.read)["order"]

    type = parsed_order["type"]
    strength = parsed_order["strength"]
    quantity = parsed_order["quantity"]

    return status 400 unless Order.valid(type, strength, quantity)

    order = Order.new(type, strength, quantity)
    serialized_order = Marshal.dump(order)
    encoded_order = Base64.urlsafe_encode64(serialized_order)

    redirect "/payment?id=#{encoded_order}", 302

  end

  get "/payment" do

    return status 406 unless request.accept?("application/json")

    encoded_order = params[:id]

    return status 400 unless encoded_order
    
    payment =
    {
      :number => 0,
      :expiry_month => 0,
      :expiry_year => 0,
      :cvv => 0
    }

    meta =
    [
      {
        :url => "/payment?id=#{encoded_order}",
        :methods => ["POST"]
      }
    ]

    {:payment => payment, :meta => meta}.to_json

  end

  post "/payment" do

    return status 406 unless request.accept?("application/json")

    encoded_order = params[:id]
    
    return status 400 unless encoded_order
    
    serialized_order = Base64.urlsafe_decode64(encoded_order)
    order = Marshal.load(serialized_order)

    parsed_payment = JSON.parse(request.body.read)["payment"]

    number = parsed_payment["number"]
    expiry_month = parsed_payment["expiry_month"]
    expiry_year = parsed_payment["expiry_year"]
    cvv = parsed_payment["cvv"]

    return status 400 unless Payment.valid(number, expiry_month, expiry_year, cvv)

    payment = Payment.new(number, expiry_month, expiry_year, cvv)
    invoice = Invoice.new(order, payment)

    serialized_invoice = Marshal.dump(invoice)
    encoded_invoice = Base64.urlsafe_encode64(serialized_invoice)

    redirect "/invoice?id=#{encoded_invoice}", 302

  end

  get "/invoice" do

    return status 406 unless request.accept?("application/json")

    encoded_invoice = params[:id]
    
    return status 400 unless encoded_invoice

    serialized_invoice = Base64.urlsafe_decode64(encoded_invoice)
    invoice = Marshal.load(serialized_invoice)

    meta =
    [
      {
        :url => "/",
        :methods => ["GET"]
      }
    ]

    {:invoice => invoice.to_s, :meta => meta}.to_json

  end

  run! if __FILE__ == $0

end
