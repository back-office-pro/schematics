# frozen_string_literal: true

module Schematics
  module Virtuals
    module Errors
      class NameError < StandardError
        def to_s = translate('errors.virtuals.name', name:)
      end
    end
  end
end
