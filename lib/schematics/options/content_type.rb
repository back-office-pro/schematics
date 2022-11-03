# frozen_string_literal: true

require 'action_dispatch/http/mime_type'

module Schematics
  module Options
    class ContentType < Option
      class << self
        def input_type = :select

        def collection = ::Mime::LOOKUP
          .values
          .map(&:symbol)
          .map(&:to_s)
      end
    end
  end
end
