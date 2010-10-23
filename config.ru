require 'haml'
require 'sinatra'
require 'json'

set :root, File.dirname(__FILE__)


helpers do
  def dicks(count)
    `dicks #{count.to_i}`
  end
end

get '/' do
  @dicks = dicks(5)
  erb :index
end

get %r#/([\d]{1,4})$# do |count|
  @dicks = dicks(count)
  erb :index
end

get %r#/([\d]{1,4}).txt# do |count|
  content_type 'text/plain', :charset => 'utf-8'
  dicks(count)
end

get %r#/([\d]{1,4}).json# do |count|
  content_type 'application/json', :charset => 'utf-8'
  {:dicks => dicks(count).split("\n")}.to_json
end

get %r#/([\d]{1,4}).xml# do |count|
  content_type 'application/xml', :charset => 'utf-8'
  @dicks = dicks(count).split("\n")
  haml :xml
end

run Sinatra::Application
