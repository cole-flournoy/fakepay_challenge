require 'net/http'
require 'json'

def rails_api_test
  uri = URI.parse('http://127.0.0.1:3000/')
  
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri)
  req.body = {'customer': {'id': '12', 'first_name': 'Cole'}}.to_json
  req["Content-Type"] = "application/json"

  response = http.start{|http| http.request(req)}
  # puts JSON.parse(response.body)
end

rails_api_test