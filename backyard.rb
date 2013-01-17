#encoding:utf-8
require 'aws/dynamo_db'
require 'securerandom'
load './dynamo.rb'

JP_WDAY = %w(日 月 火 水 木 金 土)

def pad(s) #for JSON with Padding
  "pad([" + s + "])"
end

def time
  now = Time.now
  h = {local:now.localtime.to_s, utc:now.utc.to_s}
  pad(h.to_json)
end

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


def list_notices(s)
  items = Dynamo.db.tables["notices"].load_schema.items.where(:submit_date).begins_with(s)
  jsonp_w_items(items)
end

def submit_notice(template_title)
  attrs = Dynamo.db.tables["templates"].load_schema.items[template_title].attributes
  if(attrs.count==0) then 
    return "[#{template_title}] is invalid template title."
  end
  
  h = {}
  attrs.each_key do |key| h[key] = "（記入なし）" end
  h[:title] = template_title
  h[:submit_date] = tokyo_time_with_hash
  Dynamo.db.tables["notices"].load_schema.items.put(h)
  time
end

def tokyo_time_with_hash
  tokyo = Time.now.localtime "+09:00"
  "#{tokyo.to_s} [#{SecureRandom.uuid[0,13]}]"
end

