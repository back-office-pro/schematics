# frozen_string_literal: true

require 'active_support/core_ext/enumerable'

module Schematics
  # :reek:Attribute
  class Validators
    include ::ActionView::Helpers::NumberHelper
    include ::ActiveModel::API

    delegate :==, :empty?, :any?, to: :compact_validators
    attr_accessor :name, :validators

    def compact_validators
      validators
        .transform_values { _1.try(:compact) || _1 }
        .compact_blank
    end

    def merge(other_validators)
      validators.deep_merge!(other_validators)
      self
    end

    def human(validators: compact_validators) # rubocop:disable Metrics/CyclomaticComplexity
      validators.map do |key, value|
        [
          self.class.human_attribute_name(key),
          case value
          when ::Array
            value.map(&:to_s).map(&:upcase).join(' ')
          when ::Hash
            human(validators: value)
          when ::Numeric
            number_to_human_size(value)
          when ::TrueClass
            nil
          else
            value.humanize
          end
        ].compact
      end.map { _1.join(' ') }
    end

    def to_str
      return '' if empty?

      <<~RUBY
        validates :#{name}, #{compact_validators}
      RUBY
    end
  end
end
