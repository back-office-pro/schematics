# frozen_string_literal: true

module Schematics
  module Virtuals
    module Errors
      class NoMethodError < StandardError
        def name
          super
            .to_s
            .chomp('_formatted')
        end

        def to_s
          return translate('errors.virtuals.nil') unless receiver

          translate('errors.virtuals.no_method', name:)
        end
      end
    end
  end
end
