#encoding:utf-8
require 'aws/dynamo_db'
load './dynamo_connect.rb'
load './range_key_jp.rb'

def create(template_title)
  attrs = Dynamo.db.tables["negui_templates"].load_schema.items[template_title].attributes
  if(attrs.count==0) then 
    return "[#{template_title}] is invalid template title."
  end
  h = {}
  attrs.each_key do |k|
    h[k] = "(no input, yet)"
  end 
  h[:title] = template_title
  h[:range_key] = range_key "Naohiro OHTA"
  h[:money] = 123456789
  Dynamo.db.tables["negui_records"].load_schema.items.put(h)
  "Done!"
end

