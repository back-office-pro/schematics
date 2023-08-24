# frozen_string_literal: true

module Schematics
  module Attributes
    class BelongsTo < Association
      include Behaviours::Fillable

      def available_options = super.excluding(Options::Default)

      def nested_permitted_params = {
        "#{entity.name.pluralize}_attributes": entity.permitted_params.push(:id, :_destroy)
      }

      def nested_permitted_json_params = {
        "#{entity.name.pluralize}_attributes": entity.permitted_json_params.push(:id, :destroy)
      }

      def nested_to_str = <<~RUBY
        accepts_nested_attributes_for :#{entity.name.pluralize}
      RUBY
    end
  end
end
