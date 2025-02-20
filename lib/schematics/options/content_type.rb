# Copyright © 2025 Dev & Software. All rights reserved.
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
      end
    end
  end
end
