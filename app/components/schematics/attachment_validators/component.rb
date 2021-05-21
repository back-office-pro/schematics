# frozen_string_literal: true

module Schematics
  module AttachmentValidators
    class Component < ApplicationComponent
      delegate :breadcrumb_trail, to: :helpers
      BLACKLIST = %i[presence attached].freeze

      def initialize(validators:)
        super
        @validators = validators
      end

      def humanized_validators(validators: @validators)
        validators.except(*BLACKLIST).map do |key, value|
          [
            t(".#{key}"),
            case value
            when Array
              value.map(&:to_s).map(&:upcase).join(' ')
            when Hash
              humanized_validators(validators: value)
            when Numeric
              number_to_human_size(value)
            else
              value.humanize
            end,
          ]
        end
      end
    end
  end
end
