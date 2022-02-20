# frozen_string_literal: true

module Schematics
  class Migration
    delegate :execute, to: :command

    class << self
      def build(schema, command:, entity:, timestamp:, attribute: nil)
        entity = schema.find_entity_by_name(entity)
        new(command, entity, attribute, timestamp)
      end
    end

    def initialize(command, entity, attribute, timestamp)
      @command = command
      @entity = entity
      @attribute = attribute
      @timestamp = timestamp
    end

    def migrated?
      @timestamp < ::ApplicationRecord.connection.migration_context.current_version
    end

    private

    def command
      Commands::Command.build(command: @command, entity: @entity, attribute: @attribute)
    end
  end
end
