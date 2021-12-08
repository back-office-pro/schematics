# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Virtuals
    module Errors
      class TypeError
        delegate_missing_to :@exception
        delegate :translate, to: :I18n
        REGEX = /([A-Z][a-z]+)/

        def initialize(exception)
          @exception = exception
        end

        def to_s
          translate('errors.virtuals.type', **types)
        end

        private

        def types
          %i[source target]
            .zip(
              message
                .scan(REGEX)
                .flatten
                .map(&:downcase)
                .map { "errors.virtuals.types.#{_1}" }
                .map(&method(:translate))
            ).to_h
        end
      end
    end
  end
end
