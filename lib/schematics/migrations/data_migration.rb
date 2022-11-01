# frozen_string_literal: true

module Schematics
  module Migrations
    class DataMigration < Migration
      def initialize(new_schema, current_schema)
        super(
          new_schema.entities.reject(&:core?),
          current_schema.entities.reject(&:core?)
        )
      end
    end
  end
end
