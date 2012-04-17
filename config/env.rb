path = File.expand_path '../../', __FILE__
APP = "sinforum"

require "bundler/setup"
Bundler.require :default
module Utils
  def require_all(path)
    Dir.glob("#{path}/**/*.rb") do |model|
      require model
    end
  end
end
include Utils

env = ENV["RACK_ENV"] || "development"
DataMapper.setup :default, "mysql://localhost/sinforum_#{env}"
require_all "#{path}/models"

require "#{path}/config/sinatra_exts.rb"

DataMapper.finalize