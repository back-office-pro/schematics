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

      def bound
        10**(precision - scale.to_i)
      end

      def open_api_type = ::Float

      def validators = super.merge(
        numericality: {
          greater_than: (-bound if precision),
          less_than: (bound if precision)
        }
      )

      protected

      def migration_options = super.push(
        :precision,
        :scale
      )
    end
  end
end
