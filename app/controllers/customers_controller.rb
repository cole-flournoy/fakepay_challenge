require 'net/https'
require 'pry'
require 'json'
require 'dotenv/load'

class CustomersController < ApplicationController
  PLANS = {
    'bronze': '1999',
    'silver': '4999',
    'gold': '9900'
  }

  def create
    if existing = Customer.find_by(id: customer_params[:id])
      puts "found an existing customer"
    else
      puts "setting up your purchase"
      details = customer_params[:payment]
      details[:amount] = PLANS[customer_params[:subscription][:plan].to_sym] 
      
      purchase_post_req(details)
    end   
    # binding.pry
  end

  private

  def customer_params
    params.require(:customer).permit(:id, :first_name, :last_name, subscription: [:plan, :addr_one, :addr_two, :city, :state, :zip], payment: [:card_number, :cvv, :expiration_month, :expiration_year, :zip_code])
  end

end 

def purchase_post_req(payment_details)
  uri = URI.parse('https://www.fakepay.io/purchase')
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
  req = Net::HTTP::Post.new(uri)
  req.body = payment_details.to_json
  req["Content-Type"] = "application/json"
  req["Authorization"] = "Token token=#{ENV["FAKEPAY_TOKEN"]}"
  
  response = http.start{|http| http.request(req)}
  token = JSON.parse(response.body)['token']
  binding.pry
  puts JSON.parse(response.body)
end

# purchase_post_req

# {"amount": "1000", "card_number": "4242424242424242", "cvv": "123", "expiration_month": "01", "expiration_year": "2024", "zip_code": "10045"}