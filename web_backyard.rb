# encoding:utf-8
require 'aws/dynamo_db'
load './dynamo.rb'

JP_WDAY = %w(ì˙ åé âŒ êÖ ñÿ ã‡ ìy)

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

def jsonp_w_items(items)
  s=""; first=true; items.each{|item|
    if(first) then first=false else s+="," end
    s += simple_flat_json_from_item(item)
  }
  pad(s)
end

def read_table_names
  tables = Dynamo.db.tables
  s="";first=true;tables.each{ |t|
    if(first) then first=false else s+="," end
    s += ( '{"table_name":"' + t.name + '"}' )
  }
  pad(s)
end

def hash_for_new_notice(title)
  require 'securerandom'
  id = SecureRandom.uuid; p id[0,8]
  # tbl = Dynamo.db.tables["notices"].load_schema
  {id:id, ymd:Date.today}
end

def new_absence
  h = {
    ymd:Date.today,
    section:"24",
    staff:"114",
    name:"Naohiro OHTA"
    when:Date.today+11

  }
end


def list_notices(s)
  items = Dynamo.db.tables["notices"].load_schema.items.where(:ymd).begins_with(s)
  jsonp_w_items(items)
end

def time
  now = Time.now
  h = {utc:now.utc.to_s, local:now.localtime.to_s}
  pad(h.to_json)
end



