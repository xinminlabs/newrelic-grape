require 'new_relic/agent/instrumentation'
require 'new_relic/agent/instrumentation/controller_instrumentation'
require 'grape'

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

        def route
          env['api.endpoint'].routes.first
        end

        def request_path
          path = route.route_path[1..-1].gsub('/', '-')
          path.sub!(/\(\.:format\)\z/, '')
          route.route_version && path.sub!(':version', route.route_version)

          path
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
    NewRelic::Agent::Instrumentation::MiddlewareProxy.class_eval do
      def self.needs_wrapping?(target)
        (
          !target.respond_to?(:_nr_has_middleware_tracing) &&
          !is_sinatra_app?(target) &&
          !target.is_a?(Proc)
        )
      end
    end

    ::Grape::Endpoint.class_eval do
      alias_method :origin_build_middleware, :build_middleware

      def build_middleware
        b = origin_build_middleware
        b.use ::NewRelic::Agent::Instrumentation::Grape
        b
      end
    end
  end
end
