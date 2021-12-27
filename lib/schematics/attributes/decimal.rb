# frozen_string_literal: true

module Schematics
  module Attributes
    class Decimal < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable

      delegate :scale, to: :options

      def open_api_type
        :number
      end

      def bound
        10**(precision - scale.to_i)
      end

      def validators
        validators = super
        validators[:numericality][:greater_than] = -bound if precision
        validators[:numericality][:less_than] = bound if precision
        validators
      end

      protected

      def migration_options
        super.concat %i[precision scale]
      end
    end
  end
end
