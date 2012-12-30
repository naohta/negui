require 'sinatra'
require './dynamodb.rb'
require 'aws/dynamo_db'

get '/' do "Very Merry Christmas!" end
get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end

def pad(s)
    "pad([" + s + "])"
end

get '/test/json4' do
    content_type :json
    db = Dynamodb.db
    db.tables.each{|t| puts t.name}
    tbl = db.tables['products']
    tbl.load_schema
    items = tbl.items()
    s=""; first=true; items.each{ |item|
      if(first) then first=false else s+="," end
      s += JSON.generate(item.attributes.to_h)
    }
    return pad(s)
end