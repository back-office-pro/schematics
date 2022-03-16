# frozen_string_literal: true

module Schematics
  module Commands
    class RenameAttribute < Command
      def execute
        <<~SHELL
          rails generate migration rename_#{attribute}_to_#{target}_in_#{table_name.pluralize}
        SHELL
      end
    end
  end
end
