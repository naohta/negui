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

def jsonp(list,sub_name)
  s=""; first=true; list.each{ |i|
    if(first) then first=false else s+="," end
    s += JSON.generate(eval("i."+sub_name))
    #p AWS::DynamoDB
    #p AWS::Core::Options::JSONSerializer
	#j = AWS::Core::Options::JSONSerializer.new(nil,nil)
	#p j.serialize!(eval("i."+sub_name))
    p (eval("i."+sub_name)).class
  }
  return pad(s)
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

get '/read/:table' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table]]
  tbl.load_schema
  items = tbl.items()
  jsonp(items,"attributes.to_h")
end

get '/read2/:table' do
  content_type :json
  tbl = Dynamodb.db.tables[params[:table]]
  tbl.load_schema
  items = tbl.items()
  s="";first=true;items.each{ |item|
	if(first) then first=false else s+="," end
	s += '{'
    first2=true; item.attributes.each{ |attr|
      if(first2) then first2=false else s+=',' end
      s += "\"#{attr[0]}\":"
      if(attr[1].class==BigDecimal) then
        s += "\"#{attr[1].to_i}\""
      else
        s += "\"#{attr[1]}\""
      end
      p attr[1].class
      p attr
    }
    s += '}'
  }
  pad(s)
end
