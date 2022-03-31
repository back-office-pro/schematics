# frozen_string_literal: true

module Schematics
  module AttachmentValidators
    class Component < ApplicationComponent
      DENYLIST = %i[presence attached antivirus].freeze

      def initialize(validators:)
        super
        @validators = validators.except(*DENYLIST)
      end

      def humanized_validators(validators: @validators)
        validators.map do |key, value|
          [
            t(".#{key}"),
            case value
            when ::Array
              value.map(&:to_s).map(&:upcase).join(' ')
            when ::Hash
              humanized_validators(validators: value)
            when ::Numeric
              number_to_human_size(value)
            else
              value.humanize
            end
          ]
        end
      end
    end
  end
end
