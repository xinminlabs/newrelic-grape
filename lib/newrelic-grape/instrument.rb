require 'new_relic/agent/instrumentation'
require 'new_relic/agent/instrumentation/middleware_proxy'
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
            category: :rack,
            path: "#{request_method} #{request_path}",
            request: @newrelic_request,
            params: @newrelic_request.params
          }
          perform_action_with_newrelic_trace(trace_options) do
            @app_response = @app.call(@env)
          end
        end

        def route
          env['api.endpoint'].routes.first
        end

        def request_path
          path = route.route_path[1..-1].tr('/', '-')
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
    defined?(::Grape) && ! ::NewRelic::Control.instance['disable_grape'] && !ENV['DISABLE_NEW_RELIC_GRAPE']
  end

  executes do
    NewRelic::Agent.logger.info 'Installing Grape instrumentation'
  end

  executes do
    begin
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
        if method_defined?(:build_middleware)
          alias_method :_build_middleware, :build_middleware

          def build_middleware
            b = _build_middleware
            b.use ::NewRelic::Agent::Instrumentation::Grape
            b
          end
        elsif private_method_defined?(:build_stack)
          include Grape::DSL::Middleware::ClassMethods

          alias_method :_build_stack, :build_stack

          def build_stack
            use ::NewRelic::Agent::Instrumentation::Grape
            _build_stack
          end
        end
      end
    rescue Exception => e
      STDERR.puts e
      raise e
    end
  end
end
