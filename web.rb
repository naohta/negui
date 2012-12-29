require 'sinatra'
require './dynamodb.rb'
require 'aws/sts'
require 'aws/dynamo_db'

get '/' do
  "Very Merry Christmas!"
end

get '/hello/:name' do
  "hello, #{params[:name]}:)"
end


get '/api/:uid/:hashkey/leave_notice/list' do
end

get '/test/json' do
  'pad(["some1","some2","some3"]);'
end

get '/test/json2' do
  'pad({"root":{"k1":"yas!","k2":"This is JSON one."}})'
end

get '/test/json3' do
  'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])'
end

get '/products/json' do
  content_type :json
  db = Dynamodb.db
  db.tables.each{|t| puts t.name}
  tbl = db.tables['products']
  tbl.load_schema
  items = tbl.items()
  s = "["
  
  first=true; items.each{ |item|
    if(first) then first=false else s+="," end
    s += JSON.generate(item.attributes.to_h)
  }
  s += "]"
  return s
end



get '/products/as_json5' do
  content_type :json
  db = Dynamodb.db
  db.tables.each{|t| puts t.name}
  tbl = db.tables['products']
  tbl.load_schema
  items = tbl.items()
  s = "["
  
  first=true; items.each{ |item|
    if(first) then first=false else s+="," end
    item.attributes.each{ |a|
      s += '"'
      if(a.typeof(BigDecimal)) then s += a.to_s("F"); s += "decimal"
        else s+= a.to_s end
      s += '",'
    }
  }
  s += "]"
  return s
end

get '/products/as_html' do
  db = Dynamodb.db
  db.tables.each{|t| puts t.name}
  tbl = db.tables['products']
  tbl.load_schema
  items = tbl.items()
  s = ""
  items.each{|item|
    s += "-----------------<br/>"
    item.attributes.each{|attr| s += (attr.to_s + "<br/>")}
  }
  
  return s
end

get '/products/as_json2' do
  content_type :json
  db = Dynamodb.db
  db.tables.each{|t| puts t.name}
  tbl = db.tables['products']
  tbl.load_schema
  items = tbl.items()
  s = "["
  
  first=true; items.each{ |item|
    if(first) then first=false else s+="," end
    p "item.attributes", item.attributes
    p "item.attributes.to_h", item.attributes.to_h
    p "JSON.generate(item.attributes.to_h)", JSON.generate(item.attributes.to_h)
    s += JSON.generate(item.attributes.to_h)
  }
  s += "]"
  return s
end



