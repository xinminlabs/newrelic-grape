require 'spec_helper'

describe Api::Ping do
  include Rack::Test::Methods

  def app
    App::Api
  end

  it 'ping' do
    get '/api/ping'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({ ping: 'pong' }.to_json)
  end
end
