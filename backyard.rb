#encoding:utf-8
load './stopwatch.rb'
sw = Stopwatch.new("require")
require 'aws/dynamo_db'
require 'securerandom'
load './dynamo.rb'
load './jsonp.rb'
sw.stop

JP_WDAY = %w(日 月 火 水 木 金 土)

def tokyo_time_with_hash
  tokyo = Time.now.localtime "+09:00"
  "#{tokyo.to_s} [#{SecureRandom.uuid[0,13]}]"
end

def list_notices(s)
  sw = Stopwatch.new("list_notices - Query for DynamoDB")
  # Scan API
  # items = Dynamo.db.tables["notices"].load_schema.items.where(:submit_date).begins_with(s)

  # Query API
  items = Dynamo.db.tables["notices"].load_schema.items.query(hash_value:"物品購入", range_begins_with:s)
  sw.stop
  sw = Stopwatch.new("list_notices - jsonp")
  jsonp = Jsonp.jsonp_from_dynamo_items(items)
  sw.stop
  jsonp
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
  h[:"購入金額"] = 3456789
  Dynamo.db.tables["notices"].load_schema.items.put(h)
  "done."
end

