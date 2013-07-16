# encoding: utf-8
require 'bundler/setup'
require 'sinatra/base'
require 'simple-navigation'
require 'data_mapper'
require 'less'
require 'slim'
require 'coffee_script'

require_relative 'models.rb'

module Assassins
  class App < Sinatra::Base
    configure do
      enable :method_override
      enable :logging
      enable :sessions

      SimpleNavigation.set_env(root, environment)
      helpers ::SimpleNavigation::Helpers

      DataMapper::Logger.new($stderr, settings.development? ? :debug : :info)
      DataMapper.setup(:default, ENV['DATABASE_URL'])
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    configure :development do
      set :slim, :pretty => true
    end

    get '/' do
      slim :index
    end

    get '/leaderboard' do
      players = Player.all
      slim :leaderboard, :locals => {:players => players}
    end

    get '/main.css' do
      less :main, :views => 'styles'
    end

    not_found do
      slim :coming_soon
    end
  end
end

require_relative 'user.rb'
require_relative 'static.rb'

# vim:set ts=2 sw=2 et:
