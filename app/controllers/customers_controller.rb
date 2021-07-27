require 'net/https'
require 'pry'
require 'json'
require 'dotenv/load'

class CustomersController < ApplicationController

  def create
    # if customer_params[]
    binding.pry
  end

  private

  def customer_params
    params.require(:customer).permit(:id)
  end

end 

def purchase_post_req
  uri = URI.parse('https://www.fakepay.io/purchase')
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  req = Net::HTTP::Post.new(uri)
  req.body = {"amount": "1000", "card_number": "4242424242424242", "cvv": "123", "expiration_month": "01", "expiration_year": "2024", "zip_code": "10045"}.to_json
  req["Content-Type"] = "application/json"
  req["Authorization"] = "Token token=#{ENV["FAKEPAY_TOKEN"]}"
  binding.pry
  response = http.start{|http| http.request(req)}
  token = JSON.parse(response.body)['token']
  puts JSON.parse(response.body)
end

# purchase_post_req