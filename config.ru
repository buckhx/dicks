require 'bundler/setup'
require 'haml'
require 'sinatra'
require 'json'
require 'yaml'

set :root, File.dirname(__FILE__)


helpers do
  def dicks(count)
    `bundle exec dicks #{count.to_i} 2>&1`
  end
end

get '/' do
  @dicks = dicks(5)
  @default = true
  erb :index
end

get %r#/([\d]{1,4})$# do |count|
  @dicks = dicks(count)
  erb :index
end

get %r#/([\d]{1,4}).txt# do |count|
  content_type :text
  dicks(count)
end

get %r#/([\d]{1,4}).json# do |count|
  content_type :json
  {:dicks => dicks(count).split("\n")}.to_json
end

get %r#/([\d]{1,4}).ya?ml# do |count|
  content_type :yaml
  {:dicks => dicks(count).split("\n")}.to_yaml
end

get %r#/([\d]{1,4}).xml# do |count|
  content_type :xml
  @dicks = dicks(count).split("\n")
  haml :xml
end

run Sinatra::Application
