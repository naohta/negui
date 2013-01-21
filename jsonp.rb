#encoding:utf-8
require 'aws/dynamo_db'

module Jsonp

  def self.jsonp_from_dynamo_item(dynamo_item)
    pad(json(dynamo_item))
  end

  def self.jsonp_from_dynamo_items(dynamo_items)
    s="";
    first=true;
    dynamo_items.each{ |dynamo_item|
      if(first) then first=false else s+="," end
      s += json(dynamo_item)
    }
    pad(s)
  end

  private
  def self.json(dynamo_item)
    if(dynamo_item.attributes.count==0) then return '' end
    s = '{';
    first=true;
    dynamo_item.attributes.each{ |attr|
      if(first) then first=false else s+=',' end
      key=attr[0]
      value=attr[1]
      s += '"' + key + '":"'
      s += (value.class==BigDecimal) ? value.to_i.to_s : value
      s += '"'
    }
    s += '}'
  end

  def self.pad(s) #for JSON with Padding
    "pad([" + s + "])"
  end

end
