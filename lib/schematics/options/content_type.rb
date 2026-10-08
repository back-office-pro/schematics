# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Options
    class ContentType < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = true

        def collection = ::Mime::LOOKUP
          .keys
          .sort

        def openai_type = 'array'

        def openai_description = 'The content types of the attachment'

        def openai_enum = { items: { type: 'string', enum: collection } }
      end
    end
  end
end
