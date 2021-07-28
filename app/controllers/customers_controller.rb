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
      details = {
        amount: PLANS[customer_params[:subscription][:plan].to_sym],
        token: existing.token
      }
      payment_response = fakepay_payment(details)
      if payment_response['error_code'].nil?
        puts "Payment success!"
        puts "No new Customer created"
        new_sub = Subscription.new(customer_params[:subscription])
        new_sub.customer = existing
        new_sub.save
        puts "New Subscription Created for existing"
        
        render json: existing
      else
        binding.pry
        # handle errors
      end
    else
      puts "setting up your purchase"
      details = customer_params[:payment]
      details[:amount] = PLANS[customer_params[:subscription][:plan].to_sym] 
      
      payment_response = fakepay_payment(details)
      case payment_response['error_code']
      when nil
        puts "Payment success!"
        token = payment_response['token']
        new_cust = Customer.create(first_name: customer_params[:first_name], last_name: customer_params[:last_name], token: token)
        puts "New Customer created"
        new_sub = Subscription.new(customer_params[:subscription])
        new_sub.customer = new_cust
        new_sub.save
        puts "New Subscription Created"
        
        render json: new_cust
      when 1000001
        render json: {error: "Invalid credit card number"}
      when 1000002
        render json: {error: "Insufficient funds"}
      when 1000003
        render json: {error: "CVV failure"}
      when 1000004
        render json: {error: "Expired card"}
      when 1000005
        render json: {error: "Invalid zip code"}
      when 1000006
        # Invalid purchase amount
        render json: {error: "Internal error: Your payment cannot be processed at this time, but we're working on it!"}
      when 1000007
        # Invalid token
        render json: {error: "Internal error: Your payment cannot be processed at this time, but we're working on it!"}
      when 1000008
        # Invalid params: token and cc info present
        render json: {error: "Internal error: Your payment cannot be processed at this time, but we're working on it!"}
      else
        render json: {error: "Unknown error: Your payment cannot be processed at this time, but we're working on it!"}
      end
    end   
    # binding.pry
  end

  private

  def customer_params
    params.require(:customer).permit(:id, :first_name, :last_name, subscription: [:plan, :addr_one, :addr_two, :city, :state, :zip], payment: [:card_number, :cvv, :expiration_month, :expiration_year, :zip_code])
  end

end 

def fakepay_payment(payment_details)
  uri = URI.parse('https://www.fakepay.io/purchase')
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
  req = Net::HTTP::Post.new(uri)
  req.body = payment_details.to_json
  req["Content-Type"] = "application/json"
  req["Authorization"] = "Token token=#{ENV["FAKEPAY_TOKEN"]}"
  
  response = http.start{|http| http.request(req)}
  # token = JSON.parse(response.body)['token']
  # binding.pry
  return JSON.parse(response.body)
end

# fakepay_payment
# {"amount": "1000", "card_number": "4242424242424242", "cvv": "123", "expiration_month": "01", "expiration_year": "2024", "zip_code": "10045"}