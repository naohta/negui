require 'aws/dynamo_db'
load './dynamodb.rb'

def pad(s)
  "pad([" + s + "])"
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

def read_table_names
  tables = Dynamodb.db.tables
  s="";first=true;tables.each{ |t|
    if(first) then first=false else s+="," end
    s += ( '{"table_name":"' + t.name + '"}' )
  }
  pad(s)
end


=begin
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
