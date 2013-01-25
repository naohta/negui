#encoding:utf-8
require 'aws/dynamo_db'
load './dynamo_connect.rb'
load './jsonp_from_dynamo_data.rb'

def list_notices(s)

  # Scan API
  # items = Dynamo.db.tables["notices"].load_schema.items.where(:submit_date).begins_with(s)
  
  # Query API
  items = Dynamo.db.tables["notices"].load_schema.items.query(hash_value:"物品購入", range_begins_with:s)

  Jsonp.jsonp_from_dynamo_items items
end


def one(hash_value,range_value)
  item = Dynamo.db.tables["notices"].load_schema.items[hash_value, range_value]
  Jsonp.jsonp_from_dynamo_item_attrs item
end

