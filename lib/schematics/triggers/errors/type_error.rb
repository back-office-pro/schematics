# frozen_string_literal: true

module Schematics
  module Triggers
    module Errors
      # :reek:InstanceVariableAssumption
      class TypeError < StandardError
        def to_s = translate('errors.triggers.type', **types)

        private

        def types = %i[source target]
          .zip(
            @exception
              .message
              .scan(/([A-Z][a-z]+)/)
              .flatten
              .map(&:downcase)
              .map { "errors.triggers.types.#{it}" }
              .map(&method(:translate))
          ).to_h
      end
    end
  end
end
