# frozen_string_literal: true

module Schematics
  module Virtuals
    module Errors
      class TypeError < StandardError
        def to_s = translate('errors.virtuals.type', **types)

        private

        def types = %i[source target]
          .zip(
            message
              .scan(/([A-Z][a-z]+)/)
              .flatten
              .map(&:downcase)
              .map { "errors.virtuals.types.#{_1}" }
              .map(&method(:translate))
          ).to_h
      end
    end
  end
end
