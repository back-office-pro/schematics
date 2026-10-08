# frozen_string_literal: true

module Schematics
  module Attributes
    class BelongsTo < Association
      def permitted_params
        return super unless polymorphic?

        [super, :"#{name}_type"]
      end

      memoize def inverse_association
        return super if polymorphic?
        return super if inverse_association_type == 'has_one'
        return super unless entity.can?(:create)

        Associations::HasManyNested.new(belongs_to: self)
      end

      def openai_description = 'A one-to-many association'
    end
  end
end
