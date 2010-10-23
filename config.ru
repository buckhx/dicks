require 'bundler/setup'
require 'haml'
require 'sinatra'
require 'json'
require 'yaml'

set :root, File.dirname(__FILE__)


helpers do
  def fresh_dicks(count)
    `bundle exec dicks #{count.to_i} 2>&1`
  end

  def dicks(count)
    fresh_dicks(count).split("\n")
  end
end

get '/' do
  @dicks = dicks(rand(8)+rand(5))
  @default = true
  haml :dicks
end

get %r#/([\d]{1,4})$# do |count|
  @dicks = dicks(count)
  haml :dicks
end

get %r#/([\d]{1,4})\.txt# do |count|
  content_type :text
  fresh_dicks(count)
end

get %r#/([\d]{1,4})\.json# do |count|
  content_type :json
  {:dicks => dicks(count)}.to_json
end

get %r#/([\d]{1,4})\.ya?ml# do |count|
  content_type :yaml
  {:dicks => dicks(count)}.to_yaml
end

get %r#/([\d]{1,4})\.xml# do |count|
  content_type :xml
  @dicks = dicks(count).split("\n")
  haml :xml
end

get %r#/([\d]+)# do |count|
  @count = count
  haml :too_many_dicks
end

get '/dicks.css' do
  content_type :css
  sass :dicks
end

run Sinatra::Application
