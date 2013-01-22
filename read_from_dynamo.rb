#encoding:utf-8
require 'aws/dynamo_db'
load './dynamo.rb'
load './jsonp.rb'
load './stopwatch.rb'


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

