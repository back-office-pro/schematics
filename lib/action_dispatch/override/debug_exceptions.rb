# frozen_string_literal: true

# TODO: Remove when https://github.com/rollbar/rollbar-gem/issues/1122 is addressed
module ActionDispatch
  module Override
    module DebugExceptions
      def render_exception(env, exception, wrapper = nil)
        key = 'action_dispatch.show_detailed_exceptions'

        if exception.is_a?(ActionController::RoutingError) && env[key]
          scope = extract_scope_from(env)

          Rollbar.scoped(scope) do
            report_exception_to_rollbar(env, exception)
          end
        end

        if self.class.instance_method(:render_exception_without_rollbar).arity == 2
          render_exception_without_rollbar(env, exception)
        else
          render_exception_without_rollbar(env, exception, wrapper)
        end
      end
    end
  end
end
