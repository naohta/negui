require 'aws/dynamo_db'
load './dynamo.rb'

def pad(s); "pad([" + s + "])" end #JSONP - JSON with Padding

def simple_flat_json_from_item(item)
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
  tables = Dynamo.db.tables
  s="";first=true;tables.each{ |t|
    if(first) then first=false else s+="," end
    s += ( '{"table_name":"' + t.name + '"}' )
  }
  pad(s)
end

def new_notice
  require 'securerandom'
  id = SecureRandom.uuid
  id2 = id[0,8]
  id3 = id2[0,4] + "_" + id2[4,4]
  p id
  p id2
  p id3
  tbl = Dynamo.db.tables["notices"].load_schema
  p tbl.items.put({id:id, ymd:"2011-11-11", id2:id2, title:"private"})
end

def list_notices
  items_in_2013 = Dynamo.db.tables["notices"].load_schema.items.where(:ymd).begins_with("2013")
  items_in_2013.each{|i|
    p i
  }
end
