# frozen_string_literal: true

module Schematics
  module Behaviours
    module Documentable
      def open_api_type = ::String

      def to_open_api = [name, open_api_type]
    end
  end
end
