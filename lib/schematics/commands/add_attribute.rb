# frozen_string_literal: true

module Schematics
  module Commands
    class AddAttribute < Command
      def execute
        <<~SHELL
          rails generate migration add_#{attribute}_to_#{table_name.pluralize} schema:#{name}_#{attribute}
        SHELL
      end
    end
  end
end
