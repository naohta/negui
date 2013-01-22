#encoding:utf-8
require 'aws/dynamo_db'
load './dynamo.rb'
load './range_key_jp.rb'

def submit_notice(template_title)
  attrs = Dynamo.db.tables["templates"].load_schema.items[template_title].attributes
  if(attrs.count==0) then 
    return "[#{template_title}] is invalid template title."
  end
  h = {}
  attrs.each_key do |key| h[key] = "（記入なし）" end 
  h[:title] = template_title
  h[:submit_date] = range_key "太田直宏"
  h[:"購入金額"] = 23456789
  Dynamo.db.tables["notices"].load_schema.items.put(h)
  
  "Done!"
end

