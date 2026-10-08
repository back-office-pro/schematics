# frozen_string_literal: true

module Schematics
  module Options
    class InverseAssociationType < Option
      class << self
        def input_type = :select

        def multiple? = false

        def controller = 'dropdown'

        def collection = %w[has_many has_one]
          .map { [I18n.t(it, scope: %i[activemodel attributes schematics/options/wrapper inverse_association_types]), it] } # rubocop:disable Layout/LineLength
          .sort

        def openai_type = 'string'

        def openai_description = 'The inverse type of the association'

        def openai_enum = { enum: collection.map(&:second) }
      end
    end
  end
end
