# frozen_string_literal: true

module Schematics
  module Attributes
    class BelongsTo < Association
      include Behaviours::Fillable

      def available_options = super.excluding(Options::Default)

      def inverse_association_type
        return super if polymorphic?
        return super if options.inverse_association_type == 'has_one'

        'has_many_nested'
      end
    end
  end
end
