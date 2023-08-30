# frozen_string_literal: true

module Schematics
  module Associations
    class HasManyNested < HasMany
      include Behaviours::Fillable

      def permitted_params = {
        "#{name}_attributes": entity
          .permitted_params
          .excluding(super)
          .push(:id, :_destroy)
      }

      def permitted_json_params = {
        "#{name}_attributes": entity
          .permitted_json_params
          .excluding(super)
          .push(:id, :_destroy)
      }

      def default = [entity.default]

      def to_str = super + <<~RUBY
        accepts_nested_attributes_for :#{name}
      RUBY
    end
  end
end
