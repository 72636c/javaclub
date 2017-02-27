require "base64"
require "json"
require "sinatra/base"
require "sinatra/activerecord"

require "./config/environment"
require "./models/invoice"
require "./models/order"
require "./models/payment"

class Cafe < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  error 400 do
    status 400
    erb :"400"
  end

  not_found do
    status 404
    erb :"404"
  end

  get "/" do

    return status 406 unless request.accept?("application/json")

    meta = [
      {
        :url => "/menu",
        :methods => "GET"
      }
    ]

    @json_response = {:meta => meta}.to_json

    erb :index

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

    @json_response = {:menu => menu, :meta => meta}.to_json

    erb :menu

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

    @json_response = {:order => order, :meta => meta}.to_json

    erb :order

  end

  post "/order" do

    return status 406 unless request.accept?("application/json")

    return status 400 unless request.body.size > 0

    if request.content_type =~ /json/
      begin
        parsed_order = JSON.parse(request.body.read)["order"]
        style = parsed_order["style"]
        strength = parsed_order["strength"]
        quantity = parsed_order["quantity"]
      rescue JSON::ParserError
        return status 400
      end
    elsif request.content_type =~ /x-www-form-urlencoded/
      style = params[:style]
      strength = params[:strength]
      quantity = params[:quantity].to_i
    end

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

    @json_response = {:payment => payment, :meta => meta}.to_json

    erb :payment

  end

  post "/payment" do

    return status 406 unless request.accept?("application/json")

    order_id = params[:id]

    return status 400 unless order_id && Order.exists?(order_id)
    
    order = Order.find(order_id)

    return status 400 unless request.body.size > 0

    if request.content_type =~ /json/
      begin
        parsed_payment = JSON.parse(request.body.read)["payment"]
        number = parsed_payment["number"]
        expiry_month = parsed_payment["expiry_month"]
        expiry_year = parsed_payment["expiry_year"]
        cvv = parsed_payment["cvv"]
      rescue JSON::ParserError
        return status 400
      end
    elsif request.content_type =~ /x-www-form-urlencoded/
      number = params[:number].to_i
      expiry_month = params[:expiry_month].to_i
      expiry_year = params[:expiry_year].to_i
      cvv = params[:cvv].to_i
    end

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

    @invoice = Invoice.find(invoice_id)

    meta =
    [
      {
        :url => "/",
        :methods => ["GET"]
      }
    ]

    @json_response = {:invoice => @invoice.to_s, :meta => meta}.to_json

    erb :invoice

  end

  run! if __FILE__ == $0

end
