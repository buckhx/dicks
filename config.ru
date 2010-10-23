require 'haml'
require 'sinatra'
require 'json'

set :root, File.dirname(__FILE__)

helpers do
  def dicks(count)
  @dicks = `dicks #{count} 2>&1`
  end
end

get /(\d{0,3})/ do |count|
  @dicks = `dicks #{count} 2>&1`
  erb :index
end

get /(\d{1,3}).json/ do |count|
  dicks = `dicks #{count} 2>&1`

end

run Sinatra::Application
