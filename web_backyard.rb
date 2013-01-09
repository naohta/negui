#encoding:utf-8
require 'aws/dynamo_db'
require 'securerandom'
load './dynamo.rb'

JP_WDAY = %w(日 月 火 水 木 金 土)

def time
  now = Time.now
  h = {local:now.localtime.to_s, utc:now.utc.to_s}
  pad(h.to_json)
end

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

def jsonp_w_item(item)
  pad(simple_flat_json_from_item(item))
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
  id = SecureRandom.uuid; p id[0,8]
  # tbl = Dynamo.db.tables["notices"].load_schema
  {id:id, ymd:Date.today}
end

def new_absence
  h = {
    ymd:Date.today.to_s,
    wday:JP_WDAY[Date.today.wday],
    section:"24",
    staff:"114",
    name:"Naohiro OHTA",
    when:(Date.today+11).to_s,
    title:"欠席届"
  }
  h[:id] = SecureRandom.uuid
  tbl = Dynamo.db.tables["notices"].load_schema
  tbl.items.put(h)
  h.to_s  
end

def list_notices(s)
  items = Dynamo.db.tables["notices"].load_schema.items.where(:ymd).begins_with(s)
  jsonp_w_items(items)
end

def template(title)
  item = Dynamo.db.tables["templates"].load_schema.items[title]
  jsonp_w_item(item)
end

def new_notice_w_template(template_title)
  item = Dynamo.db.tables["templates"].load_schema.items[template_title]
  attrs = item.attributes
  if(attrs.count==0) then return "This item has no attributs" end
  h = {}
  attrs.each_key{ |key|
    h[key] = "Test"
  }
  h[:title] = template_title
  h[:ymd] = Date.today.to_s
  h[:id] = SecureRandom.uuid
  p h
  p Dynamo.db.tables["notices"].load_schema.items.put(h)
  time
end


def new_application_w_template(title)
  item = Dynamo.db.tables["templates"].load_schema.items[title]
  attrs = item.attributes
  if(attrs.count==0) then return "This item has no attributs" end
  h = {}
  attrs.each_key{ |key|
    h[key] = "Test"
  }
  h[:title] = title
  h[:submit_date] = "#{Date.today.to_s} #{SecureRandom.uuid}"
  p h
  p Dynamo.db.tables["applications"].load_schema.items.put(h)
  time
end




