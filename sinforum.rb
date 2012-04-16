path = File.expand_path '../', __FILE__

require "#{path}/config/env.rb"

class Sinforum < Sinatra::Base
  @@path = File.expand_path '../', __FILE__

  set :root, @@path

  configure :development do
    use Rack::Reloader, 0
    Sinatra::Application.reset!
  end

  include Voidtools::Sinatra::ViewHelpers

  # partial :comment, { comment: "blah" }
  # partial :comment, comment

  def partial(name, value)
    locals = if value.is_a? Hash
      value
    else
      hash = {}; hash[name] = value
      hash
    end
    haml "_#{name}".to_sym, locals: locals
  end
end

require_all "#{path}/routes"

LOAD_MODULES_ROUTES.call