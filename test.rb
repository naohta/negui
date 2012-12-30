require './dynamodb.rb'
require 'aws/sts'
require 'aws/dynamo_db'

  db = Dynamodb.db
  db.tables.each{|t| puts t.name}
  tbl = db.tables['products']
  tbl.load_schema
  p tbl
  items = tbl.items
  p items
  items.each{ |i|
    p JSON.generate(i.attributes.to_h)
  }

def B
    content_type :json
    db = Dynamodb.db
    db.tables.each{|t| puts t.name}
    tbl = db.tables['products']
    tbl.load_schema
    items = tbl.items()
    s = "["
    first=true; items.each{ |item|
        if(first) then first=false else s+="," end
        s += JSON.generate(item.attributes.to_h)
    }
    s += "]"
    return s
end
