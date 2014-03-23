$:.push(File.expand_path("../lib", __FILE__))
require 'emberscope'

Emberscope.init
use Rack::Cors do
  allow do
    origins "localhost:3000"
    resource "*", headers: :any, methods: [:get, :put, :post, :delete, :options]
  end
end
run Emberscope::App
