# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Attribute
      include Behaviours::Identifiable
      include Behaviours::Inspectable
      include Behaviours::Optionable
      include Behaviours::Nameable
      include Behaviours::Migratable
      include Behaviours::Validatable

      delegate :cached?, to: :options

      attr_accessor :entity

      validates :type, presence: true
      validates :name, uniqueness: { scope: %i[entity attributes] }

      class << self
        def build(type:, **kwargs)
          Attributes.const_get(type.camelize.to_sym).new(**kwargs)
        end
      end

      def available_options = super.push(
        Options::Hidden,
        Options::Cached
      )

      def open_api_type = ::String

      def to_sql = "#{entity.table_name.pluralize}.#{column_name}"

      def to_str = ''

      def weight = 1
    end
  end
end
