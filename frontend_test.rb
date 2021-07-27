require 'net/http'
require 'json'

def rails_api_test
  uri = URI.parse('http://127.0.0.1:3000/')
  
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req.body = {"amount": "1000", "card_number": "4242424242424242", "cvv": "123", "expiration_month": "01", "expiration_year": "2024", "zip_code": "10045"}.to_json

  response = http.start{|http| http.request(req)}
  # puts JSON.parse(response.body)
end

rails_api_test