#!/usr/bin/env ruby

require 'uri'
require 'net/https'
require 'json'
require 'resolv-replace'

data = {"host_name": "dt-x00a","service_description": "File Check Passive","status_code": "0","plugin_output": "Everything is fine."}
url = URI("https://khan.op5.com/api/command/PROCESS_SERVICE_CHECK_RESULT?format=json")

request = Net::HTTP::Post.new(url)
request.basic_auth("user", "pass")
request["content-type"] = 'application/json'
request["authorization"] = 'Basic ZHR1cDpnPmQtOEt+Mys4RVU/'
request.body = data.to_json

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

response = http.request(request)
puts response.read_body
