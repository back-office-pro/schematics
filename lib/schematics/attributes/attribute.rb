# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Attribute
      include Behaviours::Specifiable
      include Behaviours::Inspectable
      include Behaviours::Optionable
      include Behaviours::Nameable
      include Behaviours::Validatable

      delegate :cached?, to: :options

      attr_accessor :id, :entity

      validates :type, presence: true
      validates :name, uniqueness: { scope: %i[entity attributes] }

      class << self
        def build(type:, **)
          Attributes.const_get(type.camelize.to_sym).new(**)
        end

        def to_proc = -> { build(**_1) }

        def collection = module_parent
          .constants
          .map(&module_parent.method(:const_get))
          .excluding(Attribute, Association, Month, Week, Year)

        def attribute_ancestors = ancestors
          .select { _1.module_parent == module_parent }
          .excluding(Attribute)

        def compatible_types = collection
          .map(&:attribute_ancestors)
          .select(&attribute_ancestors.method(:intersect?))
          .flatten
          .uniq
          .excluding(Association)
      end

      def available_options = super.push(
        Options::Hidden,
        Options::Cached
      )

      def column_name = name

      def database_type = type

      def open_api_type = ::String

      def prefixed_name = "#{entity.table_name}_#{name}"

      def to_sql = "#{entity.table_name.pluralize}.#{column_name}"

      def to_s = "schema:#{prefixed_name}"

      def to_str = ''

      def weight = 1

      protected

      def spec_interpolations = super.merge(name:, type: model_name.human)
    end
  end
end
