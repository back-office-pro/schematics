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

      def available_options = super.push(
        Options::Unit,
        Options::Precision,
        Options::Scale
      )

      def bound
        10**(precision - scale.to_i)
      end

      def default = '9.99'

      def open_api_type = ::Float

      def validators = super.merge(
        numericality: {
          greater_than: (-bound if precision),
          less_than: (bound if precision)
        }
      )
    end
  end
end
