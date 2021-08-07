# frozen_string_literal: true

module Schematics
  class Migration
    class << self
      def create(schema, action:, entity:, timestamp:, attribute: nil)
        entity = schema.find_entity_by_name(entity)
        new(action, entity, attribute, timestamp)
      end
    end

    def initialize(action, entity, attribute, timestamp)
      @action = action
      @timestamp = timestamp
      @entity = entity
      @attribute = attribute
    end

    def migrated?
      @timestamp < ::ApplicationRecord.connection.migration_context.current_version
    end

    def run
      System.send(@action.to_sym, *[@entity, @attribute].compact)
    end
  end
end
