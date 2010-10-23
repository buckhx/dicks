require 'haml'
require 'sass'
require 'sinatra/base'
require 'json'
require 'yaml'

class DicksApp < Sinatra::Base
  enable :static
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
    @dicks = dicks(rand(15) + 1)
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
    @dicks = dicks(count)
    haml :xml, :layout => false
  end

  get %r#/([\d]+)# do |count|
    @count = count
    haml :too_many_dicks
  end

  get '/business_development' do
    haml :business_development
  end

  get '/dicks.css' do
    content_type :css
    sass :dicks
  end
end
