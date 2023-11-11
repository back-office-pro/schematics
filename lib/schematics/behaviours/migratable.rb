# frozen_string_literal: true

module Schematics
  module Behaviours
    module Migratable
      def database_index_type = :btree

      def migration_options = {}
    end
  end
end
