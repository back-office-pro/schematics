# frozen_string_literal: true

module Schematics
  module Attributes
    class BelongsTo < Association
      include Behaviours::Fillable

      def available_options = super.excluding(Options::Default)

      def permitted_params
        return super unless polymorphic?

        [super, :"#{name}_type"]
      end

      def inverse_association_type = super
        .then_tap { "#{super}_nested" if !polymorphic? && super == 'has_many' }
    end
  end
end
