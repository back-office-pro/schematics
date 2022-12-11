# frozen_string_literal: true

require 'active_record'
require 'active_record/attribute_methods'
require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Attribute
      include Behaviours::Inspectable
      include Behaviours::Migratable
      include Behaviours::Validatable
      include ::ActiveModel::API

      delegate :hidden?, :cached?, to: :options
      delegate :core?, to: :entity, private: true
      delegate :keys, to: :options, prefix: true, private: true
      attr_accessor :entity, :name
      attr_writer :id, :options

      validates :options_keys, inclusion: { in: :available_options_names }
      validates :name, english: true, unless: :core?
      validates :name,
                presence: true,
                format: { with: /\A(\w+)\z/, message: :name },
                length: { maximum: 50 },
                exclusion: { in: :reserved_names }

      class << self
        def build(type:, **kwargs)
          Attributes.const_get(type.camelize.to_sym).new(**kwargs)
        end
      end

      alias options_attributes= options=

      def id
        @id ||= SecureRandom.uuid
      end

      def open_api_type = ::String

      def options
        Options::Wrapper.new(options: @options)
      end

      def to_sql = "#{entity.table_name.pluralize}.#{name}"

      def to_str = ''

      def weight = 1

      protected

      def available_options_names = available_options.map(&:name)

      def reserved_names = ::ActiveRecord::AttributeMethods
        .dangerous_attribute_methods
        .to_a
        .concat(entity.attributes.excluding(self).map(&:name))
    end
  end
end
