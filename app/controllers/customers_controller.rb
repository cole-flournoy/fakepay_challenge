require 'net/https'
require 'pry'
require 'json'

class CustomersController < ApplicationController

  def create
    
  end

  private

  def customer_params
    params.require(:customer)
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
  req["Authorization"] = "Token token=cfc65ad1671a865ba28c4911126ce9"

  response = http.start{|http| http.request(req)}
  token = JSON.parse(response.body)['token']
  puts JSON.parse(response.body)
end