# frozen_string_literal: true

module Schematics
  module Behaviours
    module Documentable
      def open_api_schema_type = 'string'

      def to_open_api_schema = [name.to_sym, open_api_schema_type]
    end
  end
end
