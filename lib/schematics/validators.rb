# frozen_string_literal: true

require 'active_support/core_ext/enumerable'

module Schematics
  # :reek:Attribute
  class Validators
    include ::ActiveModel::API

    delegate :==, :empty?, to: :compact_validators
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

    def to_str
      return '' if empty?

      <<~RUBY
        validates :#{name}, #{compact_validators}
      RUBY
    end
  end
end
