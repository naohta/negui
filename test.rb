#encoding:utf-8
require "net/http"

def json_from_jsonp(jsonp)
  startword = "pad("
  endword = ")"
  json = jsonp[startword.size, jsonp.size - startword.size - endword.size]
end

def hash_from_jsonp(jsonp)
  require "json"
  hash = JSON.parse(json_from_jsonp(jsonp))
end

puts
puts '------------'
puts 'Let us request notices list to kuwai system, by "list" method.'
puts 'Type param like "2013" or "2013-01" or "2013-01-18 15:02" and press return key!'
puts '------------'
puts
print "Type! > "
s = gets
puts "Asking..."
param = ("/list/" + s).rstrip


res = nil
Net::HTTP.start("localhost",4567) { |http|
  res = http.get(param)
}

puts
puts '------------'
puts res["content-type"]
puts

puts '------------'
puts "Type some key to continue ..."
puts "JSON"
gets
puts json_from_jsonp(res.body)
puts

puts '------------'
puts "Type some key to continue ..."
puts "Ruby's hash objects"
gets
hash_from_jsonp(res.body).each do |i|
  puts i
  puts
end
puts
