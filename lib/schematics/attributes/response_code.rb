# frozen_string_literal: true

require 'rack/utils'

module Schematics
  module Attributes
    class ResponseCode < Integer
      include Behaviours::Unincrementable

      def available_options = super.excluding(Options::Unit)

      def format(value)
        [value, ::Rack::Utils::HTTP_STATUS_CODES[value]]
          .compact
          .join(' ')
      end

      def openai_description = 'An attribute which represents a HTTP response code'

      def icon = :hashtag
    end
  end
end
