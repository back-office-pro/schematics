# frozen_string_literal: true

module Schematics
  module Options
    class Normalization < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = false

        def collection = %w[capitalize upcase downcase]
          .map { [I18n.t(it, scope: %i[activemodel attributes schematics/options/wrapper normalizations]), it] } # rubocop:disable Layout/LineLength
          .sort

        def openai_type = 'string'

        def openai_description = 'The text formatting'

        def openai_enum = { enum: collection.map(&:second) }
      end
    end
  end
end
