require 'sinatra'
def load_backyard;load './web2backyard.rb';end
load_backyard

get '/' do "Happy New Year! Are u fine?" end
get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end
get '/test/params/*:*' do |a,b| "Key is '#{a}', value is '#{b}'." end

get '/load' do load_backyard;"Backyard programs are loaded." end
get '/read' do content_type:json;read_table_names end



=begin
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
=end
