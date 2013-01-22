#encoding:utf-8
require 'sinatra'
def load_backyard
  load './write_to_dynamo.rb'
  load './read_from_dynamo.rb'
end
load_backyard

get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end
get '/test/params/*:*' do |a,b| "Key is '#{a}', value is '#{b}'." end


before do
  content_type:json
end


get '/read' do read_table_names end
get '/load' do load_backyard; "Backyard programs are loaded." end
get '/time' do time end


get '/list/*' do |s| list_notices s end
get '/submit/*' do |title| submit_notice(title) end

get '/template/*' do |title| template title end
