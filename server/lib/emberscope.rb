require 'yaml'
require 'sinatra'
require 'active_record'
require 'active_model_serializers'
require 'rack/cors'

require 'emberscope/app'
require 'emberscope/models/post'


module Emberscope
  def self.init
    raise "missing DATABASE_ENV" unless database_env
    ActiveRecord::Base.establish_connection(db_config)
  end

  def self.root
    File.expand_path("../../", __FILE__)
  end

  def self.database_env
    ENV["DATABASE_ENV"]
  end

  def self.db_config
    YAML.load(File.read(File.expand_path("config/database.yml", root)))[database_env]
  end
end
