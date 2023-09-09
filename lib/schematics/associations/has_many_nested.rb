# frozen_string_literal: true

module Schematics
  module Associations
    class HasManyNested < HasMany
      include Behaviours::Fillable

      def permitted_params = {
        attributes_param_key => entity
          .permitted_params
          .excluding(super)
          .push(:id, :_destroy)
      }

      def permitted_json_params = {
        attributes_param_key => entity
          .permitted_json_params
          .excluding(super)
          .push(:id, :_destroy)
      }

      def input_name = "#{entity.name}[#{attributes_param_key}]"

      def default = [entity.default]

      def to_str = super.concat(accepts_nested_attributes_for_to_str)

      private

      def attributes_param_key = :"#{name}_attributes"

      def accepts_nested_attributes_for_to_str = <<~RUBY
        accepts_nested_attributes_for :#{name}
      RUBY
    end
  end
end
