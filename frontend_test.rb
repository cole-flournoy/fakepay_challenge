require 'net/http'
require 'json'

def new_user_request
  uri = URI.parse('http://127.0.0.1:3000/')
  
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req.body = {
    'customer': {
      'id': nil, 
      'first_name': 'Cole',
      'last_name': 'Flournoy', 
      'subscription': {
        'plan': 'silver' 
      }, 
      'payment': {
        'card_number': '4242424242424242',
        'cvv': '123',
        'expiration_month': '01',
        'expiration_year': '2024',
        'zip_code': '10045'
      }
    }
  }.to_json
  req["Content-Type"] = "application/json"

  response = http.start{|http| http.request(req)}
end

def existing_user_request
  uri = URI.parse('http://127.0.0.1:3000/')
  
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req.body = {
    'customer': {
      'id': 1,  
      'subscription': {
        'plan': 'bronze' 
      } 
    }
  }.to_json
  req["Content-Type"] = "application/json"

  response = http.start{|http| http.request(req)}
end


# new_user_request
# existing_user_request
