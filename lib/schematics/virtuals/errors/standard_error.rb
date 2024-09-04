# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Virtuals
    module Errors
      class StandardError
        include Behaviours::Renderable
        delegate_missing_to :@exception

        class << self
          def build(exception)
            exception.exception(Errors.const_get(exception.class.to_s).new(exception))
          end
        end

        def initialize(exception)
          @exception = exception
        end
      end
    end
  end
end
