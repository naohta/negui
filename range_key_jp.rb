#encoding:utf-8
require 'securerandom'

DAY = %w(日 月 火 水 木 金 土)

def a_part_of_uuid  #like [e4f0202b-c68c]
  "[#{SecureRandom.uuid[0,13]}]"
end

def tokyo
  Time.now.localtime "+09:00"
end

def ymd(time)
  "#{time.strftime("%Y-%m-%d")}(#{DAY[time.wday]})";
end

def hm(time)
  time.strftime("%H:%M");
end

def range_key(s)
  snapshot = tokyo
  "#{ymd snapshot} #{s} #{hm snapshot} #{a_part_of_uuid}"
end


#---Compare snapshoted one & another.---
# snapshot=tokyo; 13456.times do; puts snapshot.to_s end #snapshoted one
# 13456.times do; puts tokyo.to_s end #another one

#---For Simple Test---
#puts range_key "太田直宏"
