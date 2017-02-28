require "json"
require "nokogiri"
require "rack/test"
require "rspec"

require "./app"

def get_url(html_doc)
  json_response = Nokogiri::HTML(html_doc).search("#json-response").text
  JSON.parse(json_response)["meta"][0]["url"]
end

describe "Cafe" do

  include Rack::Test::Methods

  def app()
    Cafe
  end

  it "can serve a customer" do
    url = "/"

    # GET /
    get url
    url = get_url(last_response.body)
    expect(last_response).to be_ok

    expect(url).to eq("/menu")

    # GET /menu
    get url
    url = get_url(last_response.body)
    expect(last_response).to be_ok

    expect(url).to eq("/order")

    # GET /order
    get url
    url = get_url(last_response.body)
    expect(last_response).to be_ok

    expect(url).to eq("/order")

    # POST /order -> GET /payment
    body =
    {
      :order => {:style => "latte", :strength => "strong", :quantity => 1},
      :meta => [{:url => url, :methods => ["POST"]}]
    }
    post url, body.to_json, {"CONTENT_TYPE" => "application/json"}
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_response).to be_ok

    url = get_url(last_response.body)
    expect(url).to start_with("/payment")

    # POST /payment -> GET /invoice
    body =
    {
      :payment => {:number => "1234123412341234", :expiry_month => Date.today.month, :expiry_year => Date.today.year, :cvv => "123"},
      :meta => [{:url => url, :methods => ["POST"]}]
    }
    post url, body.to_json, {"CONTENT_TYPE" => "application/json"}
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_response).to be_ok

    url = get_url(last_response.body)
    expect(url).to eq("/")
    expect(last_response.body).to include("latte")
    expect(last_response.body).to include("strong")
    expect(last_response.body).to include("1")

  end

end
