require "httparty"
require "json"
require "rspec"

describe "Cafe" do

  before(:all) do
    @host = "http://localhost:4567"
  end
  
  it "can serve a customer" do
    url = "/"
    
    # GET /
    response = HTTParty.get(@host + url)
    url = JSON.parse(response)["meta"][0]["url"]
    expect(response.code).to eq(200)
    expect(url).to eq("/menu")

    # GET /menu
    response = HTTParty.get(@host + url)
    url = JSON.parse(response)["meta"][0]["url"]
    expect(response.code).to eq(200)
    expect(url).to eq("/order")

    # GET /order
    response = HTTParty.get(@host + url)
    url = JSON.parse(response)["meta"][0]["url"]
    expect(response.code).to eq(200)
    expect(url).to eq("/order")

    # POST /order -> GET /payment
    response = HTTParty.post(
      @host + url,
      :body =>
      {
        :order => {:type => "latte", :strength => "strong", :quantity => 1},
        :meta => [{:url => url, :methods => ["POST"]}]
      }.to_json)
    url = JSON.parse(response)["meta"][0]["url"]
    expect(response.code).to eq(200)
    expect(url).to start_with("/payment")

    # POST /payment -> GET /invoice
    response = HTTParty.post(
      @host + url,
      :body =>
      {
        :payment => {:number => 1234123412341234, :expiry_month => 12, :expiry_year => 1900, :cvv => 123},
        :meta => [{:url => url, :methods => ["POST"]}]
      }.to_json)
    url = JSON.parse(response)["meta"][0]["url"]
    expect(response.code).to eq(200)
    expect(url).to eq("/")

  end

end
