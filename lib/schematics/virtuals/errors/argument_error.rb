# frozen_string_literal: true

module Schematics
  module Virtuals
    module Errors
      class ArgumentError < StandardError
        def to_s = translate('errors.virtuals.argument')
      end
    end
  end
end
