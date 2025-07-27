# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Triggers
    module Errors
      class StandardError < ::StandardError
        include Behaviours::Renderable

        delegate_missing_to :@exception

        class << self
          def build(exception)
            exception.exception(Errors.const_get(exception.class.to_s).new(exception))
          end
        end

        def initialize(exception)
          super
          @exception = exception
        end
      end
    end
  end
end
