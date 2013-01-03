require 'sinatra'
require './dynamodb.rb'
require 'aws/dynamo_db'
require 'aws/core/options/json_serializer'

get '/' do "Very Merry Christmas!" end
get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end
get '/test/params/*:*' do |a,b|
  p a,b
end

def pad(s)
  "pad([" + s + "])"
end

get '/read' do
  content_type:json
  tables = Dynamodb.db.tables
  s="";first=true;tables.each{ |t|
    if(first) then first=false else s+="," end
    s += ( '{"table_name":"' + t.name + '"}' )
  }
  pad(s)
end

def json_from_item(item)
  if(item.attributes.count==0) then return '' end
  s = '{';
  first=true; item.attributes.each{ |attr|
    if(first) then first=false else s+=',' end
    key=attr[0]; value=attr[1]
    s += '"' + key + '":"'
    s += (value.class==BigDecimal) ? value.to_i.to_s : value
    s += '"'
  }
  s += '}'
end

get '/read/:table_name' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  items = tbl.items
  s="";firstA=true;items.each{ |item|
    if(firstA) then firstA=false else s+="," end
    s += json_from_item(item)
  }
  pad(s)
end

get '/read/:table_name/:hash_key' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  pad(json_from_item(tbl.items[params[:hash_key]]))    
end

get '/write/:table_name/:hash_key' do
  content_type:json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  p :hash_key
  p "#{:hash_key}"
  #item = tbl.items.create('id'=> params[:hash_key])
  item = tbl.items.create(id:params[:hash_key])
end


get '/write2/:table_name/:hash_of_hash_key' do
  content_type:json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  p params[:hash_of_hash_key]
  item = eval("tbl.items.create(#{params[:hash_of_hash_key]})")
end

