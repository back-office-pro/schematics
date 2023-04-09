# frozen_string_literal: true

module Schematics
  module Attributes
    class String < Attribute
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Listable

      delegate :limit, to: :options

      def available_options = super.push(
        Options::Unique,
        Options::Min,
        Options::Limit,
        Options::Length
      )

      def database_type = 'string'

      def default = SecureRandom.base58(limit || 10)

      def icon = :align_justify

      def validators = super.merge(
        length: {
          minimum: options.min,
          maximum: options.limit,
          is: options.length
        }
      )

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def format(value)
        value&.to_s
      end
    end
  end
end
