require "base64"
require "json"
require "sinatra"
require "sinatra/activerecord"

require "./config/environment"
require "./models/invoice"
require "./models/order"
require "./models/payment"

class JavaClub < Sinatra::Base

  register Sinatra::ActiveRecordExtension

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
      :style => Order::STYLES,
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
      :style => "",
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

    return status 400 unless request.body.size > 0

    parsed_order = JSON.parse(request.body.read)["order"]

    style = parsed_order["style"]
    strength = parsed_order["strength"]
    quantity = parsed_order["quantity"]

    # TODO: investigate ActiveRecord validation
    return status 400 unless Order.valid(style, strength, quantity)

    order = Order.create(style: style, strength: strength, quantity: quantity)

    # TODO: generate GUID
    redirect "/payment?id=#{order.id}", 302

  end

  get "/payment" do

    return status 406 unless request.accept?("application/json")

    order_id = params[:id]

    return status 400 unless order_id && Order.exists?(order_id)

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
        :url => "/payment?id=#{order_id}",
        :methods => ["POST"]
      }
    ]

    {:payment => payment, :meta => meta}.to_json

  end

  post "/payment" do

    return status 406 unless request.accept?("application/json")

    order_id = params[:id]

    return status 400 unless order_id && Order.exists?(order_id)
    
    order = Order.find(order_id)

    return status 400 unless request.body.size > 0

    parsed_payment = JSON.parse(request.body.read)["payment"]

    number = parsed_payment["number"]
    expiry_month = parsed_payment["expiry_month"]
    expiry_year = parsed_payment["expiry_year"]
    cvv = parsed_payment["cvv"]

    # TODO: investigate ActiveRecord validation
    return status 400 unless Payment.valid(number, expiry_month, expiry_year, cvv)

    payment = Payment.create(number: number, expiry_month: expiry_month, expiry_year: expiry_year, cvv: cvv)
    invoice = Invoice.create(order: order, payment: payment)

    # TODO: generate GUID
    redirect "/invoice?id=#{invoice.id}", 302

  end

  get "/invoice" do

    return status 406 unless request.accept?("application/json")

    invoice_id = params[:id]
    
    return status 400 unless invoice_id && Invoice.exists?(invoice_id)

    invoice = Invoice.find(invoice_id)

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
