# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Entities
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Descriptor
      include ::ActiveModel::API

      validates :field_name, allow_nil: true, inclusion: { in: :allowed_field_names }

      delegate :name, :to_sql, to: :field
      attr_accessor :entity, :field_name

      alias to_s field_name

      def joins = Array(field.try(:preload))

      def to_str = <<~RUBY
        def to_s
          #{name}_formatted || id_formatted
        end
      RUBY

      def allowed_field_names = entity
        .nameable_fields
        .map(&:name)
        .sort

      def field
        entity.find_field_by_name(@field_name || 'id')
      end
    end
  end
end
