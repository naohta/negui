require 'sinatra'
require './dynamodb.rb'
require 'aws/dynamo_db'
require 'aws/core/options/json_serializer'

get '/' do "Very Merry Christmas!" end
get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end

def pad(s)
  "pad([" + s + "])"
end

get '/read/tables' do
  content_type:json
  tables = Dynamodb.db.tables
  s="";first=true;tables.each{ |t|
    if(first) then first=false else s+="," end
    s += ( '{"table_name":"' + t.name + '"}' )
  }
  pad(s)
end

get '/read/table/:table_name' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  items = tbl.items
  s="";firstA=true;items.each{ |item|
	if(firstA) then firstA=false else s+="," end
	s += '{'
    firstB=true; item.attributes.each{ |attr|
      if(firstB) then firstB=false else s+=',' end
      s += "\"#{attr[0]}\":"
      if(attr[1].class==BigDecimal) then
        s += "\"#{attr[1].to_i}\""
      else
        s += "\"#{attr[1]}\""
      end
    }
    s += '}'
  }
  pad(s)
end

get '/read/item/:table_name/:hash_key' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table_name]]
  tbl.load_schema
  item = tbl.items[params[:hash_key]]
  p item.attributes.count
  s = '{'; firstB=true; item.attributes.each{ |attr|
    p attr
    if(firstB) then firstB=false else s+=',' end
    s += "\"#{attr[0]}\":"
    if(attr[1].class==BigDecimal) then
      s += "\"#{attr[1].to_i}\""
    else
      s += "\"#{attr[1]}\""
    end
  }
  s += '}'
  p s
  p pad(s)
  pad(s)    
end
