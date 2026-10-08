# frozen_string_literal: true

module Schematics
  module Attributes
    class Decimal < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable
      include Behaviours::Incrementable

      delegate :scale, to: :options

      def available_options = super.push(
        Options::Unit,
        Options::Precision,
        Options::Scale,
        Options::Separator,
        Options::Delimiter
      )

      def bound
        10**(precision - scale.to_i)
      end

      def default
        super&.to_s || '9.99'
      end

      def openai_description = 'An attribute which represents a decimal'

      def open_api_schema_type = 'float'

      def validators = super.merge(
        numericality: {
          greater_than: (-bound if precision),
          less_than: (bound if precision)
        }
      )
    end
  end
end
