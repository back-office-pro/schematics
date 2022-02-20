# frozen_string_literal: true

module Schematics
  module Commands
    class RemoveAttribute < Command
      def execute
        <<~SHELL
          rails generate migration remove_#{@attribute}_from_#{table_name.pluralize} schema:#{name}_#{@attribute}
        SHELL
      end
    end
  end
end
