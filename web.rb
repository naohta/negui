require 'sinatra'
def load_backyard
  load './web_backyard.rb'
end
load_backyard

get '/' do "Hello!" end
get '/hello/:name' do "hello, #{params[:name]}:)" end
get '/test/json' do 'pad(["some1","some2","some3"]);' end
get '/test/json2' do 'pad([{"root":{"k1":"yas!","k2":"This is JSON one."}}])' end
get '/test/json3' do 'pad([{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}])' end
get '/test/params/*:*' do |a,b| "Key is '#{a}', value is '#{b}'." end

get '/load' do load_backyard; "Backyard programs are loaded." end
get '/read' do content_type:json; read_table_names end
get '/new' do content_type:json; new_absence end
get '/list/*' do |ymd| content_type:json; list_notices ymd; end
get '/time' do content_type:json; time end
get '/templ/*' do |title| content_type:json; list_templates title end

