require_relative 'app'

protected_app = Rack::Builder.new do
  use Rack::Auth::Basic, 'Protected' do |username, password|
    username == 'master' && password == 'mathematics'
  end

  map '/' do
    run App.new
  end
end

run protected_app
