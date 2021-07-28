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
        'plan': 'silver',
        'addr_one': '123 Red St',
        'addr_two': 'Suite 500',
        'city': 'Atlanta',
        'state': 'Georgia',
        'zip': '12345' 
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
      'id': 2,  
      'subscription': {
        'plan': 'bronze',
        'addr_one': '123 Red St',
        'addr_two': 'Suite 500',
        'city': 'Atlanta',
        'state': 'Georgia',
        'zip': '12345' 
      } 
    }
  }.to_json
  req["Content-Type"] = "application/json"

  response = http.start{|http| http.request(req)}
end

def new_user_with_error
  uri = URI.parse('http://127.0.0.1:3000/')
  
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req.body = {
    'customer': {
      'id': nil, 
      'first_name': 'Cole',
      'last_name': 'Flournoy', 
      'subscription': {
        'plan': 'silver',
        'addr_one': '123 Red St',
        'addr_two': 'Suite 500',
        'city': 'Atlanta',
        'state': 'Georgia',
        'zip': '12345' 
      }, 
      'payment': {
        # invalid CC number
        'card_number': '4242424242424241',
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


# new_user_request
# existing_user_request
# new_user_with_error

