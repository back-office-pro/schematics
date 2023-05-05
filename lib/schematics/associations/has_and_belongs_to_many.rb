# frozen_string_literal: true

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Identifiable
      include Behaviours::Optionable
      include Behaviours::Validatable
      include Behaviours::Fillable

      delegate :includes, :descriptor, :class_name, to: :inverse_entity
      delegate :options, to: :belongs_to

      validates :association_type, inclusion: { in: :allowed_association_types }

      def available_options = [
        Options::Required,
        Options::Hidden,
        Options::Type,
        Options::GroupBy
      ]

      def icon
        inverse_entity&.icon || :link
      end

      def column_name = "#{name.singularize}_ids"

      def default = []

      def permitted_params = { super => [] }

      def source = inverse_of.pluralize

      def to_str = <<~RUBY
        #{type} :#{name}, class_name: '#{class_name}'
      RUBY

      def inverse_entity = schema.find_entity_by_name(association_type)

      def association_type = super.singularize

      def allowed_association_types = entity
        .schema
        .entities
        .map(&:name)
        .sort
    end
  end
end
