module App
  class Api < Grape::API
    prefix 'api'
    format :json

    mount ::Api::Ping
  end
end
