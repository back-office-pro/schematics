# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      delegate :acceptance, to: :options

      def available_options = super.push(Options::Acceptance)

      def default = false # rubocop:disable Naming/PredicateMethod

      def icon = :toggle_on

      def open_api_schema_type = 'boolean'

      def search_predicate = :true

      def format(value)
        translate(value, default: value.to_s).upcase
      end

      def validators = super.merge(acceptance:)

      def to_str
        return super if options.default

        super + <<~RUBY
          attribute :#{name}, default: -> { false }
        RUBY
      end
    end
  end
end
