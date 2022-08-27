# frozen_string_literal: true

module Schematics
  module Migrations
    class CoreMigration < Migration
      def initialize(current_entities = [])
        super(Schema.instance.entities.select(&:core?), current_entities)
      end
    end
  end
end
