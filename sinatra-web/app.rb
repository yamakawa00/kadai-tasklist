require 'sinatra'

get '/' do
  erb :index
end

post '/' do
    puts params['target_name']
  erb :index
end