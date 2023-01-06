# frozen_string_literal: true

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable
      delegate :includes, :icon, to: :inverse_entity

      validates :name, inclusion: { in: :allowed_names }

      def column_name = "#{name.singularize}_ids"

      def default = nil

      def permitted_params = { super => [] }

      def source = inverse_of.pluralize

      def to_str = <<~RUBY
        #{type} :#{name}
      RUBY

      def inverse_entity = schema.find_entity_by_name(name.singularize)

      def allowed_names = entity
        .schema
        .entities
        .map(&:name)
        .sort
    end
  end
end
