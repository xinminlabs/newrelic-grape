require 'new_relic/agent/instrumentation/controller_instrumentation'

module NewRelic
  module Agent
    module Instrumentation
      class Grape < ::Grape::Middleware::Base
        include ControllerInstrumentation

        def call!(env)
          @env = env
          @newrelic_request = ::Rack::Request.new(env)
          trace_options = {
            :category => :rack,
            :path => "#{request_method} #{request_path}",
            :request => @newrelic_request,
            :params => @newrelic_request.params
          }
          perform_action_with_newrelic_trace(trace_options) do
            @app_response = @app.call(@env)
          end
        end

        def request_path
          env['api.endpoint'].routes.first.route_path[1..-1].gsub("/", "-").sub(/\(\.:format\)\z/, "")
        end

        def request_method
          @newrelic_request.request_method
        end

      end
    end
  end
end

DependencyDetection.defer do
  @name = :grape

  depends_on do
    defined?(::Grape) && ! ::NewRelic::Control.instance['disable_grape'] && ! ENV['DISABLE_NEW_RELIC_GRAPE']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Grape instrumentation'
  end

  executes do
    ::Rack::Builder.class_eval do
      alias_method :origin_use, :use

      def use(middleware, *args, &block)
        if middleware == Grape::Middleware::Error
          use ::NewRelic::Agent::Instrumentation::Grape
        end
        origin_use(middleware, *args, &block)
      end
    end
  end
end
