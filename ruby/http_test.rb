#!/usr/bin/env ruby

require 'uri'
require 'net/https'
require 'json'
require 'resolv-replace'

data = {"host_name": "dt-x00a","service_description": "File Check Passive","status_code": "0","plugin_output": "Everything is fine."}
url = URI("https://khan.op5.com/api/command/PROCESS_SERVICE_CHECK_RESULT?format=json")

# 0 to disable SSL verification, 1 to enable
verify = 0

request = Net::HTTP::Post.new(url)
request.basic_auth("user", "password")
request["content-type"] = 'application/json'
request.body = data.to_json

response = Net::HTTP.start(url.host, url.port, :use_ssl => true, :verify_mode => verify) {|http|
  http.request(request)
}

puts response.read_body
