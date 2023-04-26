# frozen_string_literal: true

module Schematics
  module Migrations
    class CoreMigration < Migration
      def initialize(new_schema, current_entities = [])
        super(
          new_schema.entities.select(&:core?).reject(&:existing?),
          current_entities
        )
      end
    end
  end
end
