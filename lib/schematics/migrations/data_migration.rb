# frozen_string_literal: true

module Schematics
  module Migrations
    class DataMigration < Migration
      def initialize(schema)
        super(
          schema.entities.reject(&:core?),
          Schema.instance.entities.reject(&:core?)
        )
      end
    end
  end
end
