# frozen_string_literal: true

require 'active_record'

module Schematics
  module Attributes
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Attribute
      include Behaviours::Migratable
      include Behaviours::Validatable
      include ::ActiveModel::API

      delegate :hidden?, :cached?, to: :options
      delegate :keys, to: :options, prefix: true
      attr_accessor :entity, :name
      attr_writer :options

      validates :options_keys, inclusion: { in: :available_options }
      validates :name,
                presence: true,
                length: { maximum: 50 },
                exclusion: { in: ::ActiveRecord::AttributeMethods.dangerous_attribute_methods }

      class << self
        def build(type:, **kwargs)
          Attributes.const_get(type.camelize.to_sym).new(**kwargs)
        end
      end

      def open_api_type = ::String

      def options
        Schematics::Options.new(options: @options)
      end

      def to_sql = [
        entity.table_name.pluralize,
        name
      ].join('.')

      def to_str = ''

      def weight = 1
    end
  end
end
