# frozen_string_literal: true

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable

      validates :name, inclusion: { in: :allowed_names }

      def column_name = super.pluralize

      def default = nil

      def permitted_params = {
        super => []
      }

      def source = inverse_of.pluralize

      def to_str = <<~RUBY
        #{type} :#{name}
      RUBY

      private

      def allowed_names = entity
        .schema
        .entities
        .map(&:name)
    end
  end
end
