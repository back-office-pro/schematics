# frozen_string_literal: true

module Schematics
  module Commands
    class ChangeAttribute < Command
      def execute
        <<~SHELL
          rails generate migration change_#{attribute}_in_#{table_name.pluralize} schema:#{name}_#{attribute}
        SHELL
      end
    end
  end
end
