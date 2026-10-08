# frozen_string_literal: true

module Schematics
  module Options
    class AspectRatio < Option
      class << self
        def input_type = :select

        def multiple? = true

        def controller = 'dropdown'

        def collection = %w[landscape square is_16_9 is_4_3]
          .map { [I18n.t(it, scope: %i[activemodel attributes schematics/options/wrapper aspect_ratios]), it] } # rubocop:disable Layout/LineLength
          .sort

        def openai_type = 'array'

        def openai_description = 'The aspect ratios of the image'

        def openai_enum = { items: { type: 'string', enum: collection.map(&:second) } }
      end
    end
  end
end
