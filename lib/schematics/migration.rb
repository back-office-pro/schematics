# frozen_string_literal: true

module Schematics
  class Migration
    def initialize(current_schema, new_schema)
      @current_schema = current_schema
      @new_schema = new_schema
    end

    def commands = new_data
      .difference(current_data)
      .map { @new_schema.find_entity_by_name(_1[:name]) }
      .map { |entity| Commands::CreateEntity.new(entity:) }
      .concat(
        current_data
          .difference(new_data)
          .map { @current_schema.find_entity_by_name(_1[:name]) }
          .map { |entity| Commands::DestroyEntity.new(entity:) }
      )
      .concat(
        new_data
          .pluck(:attributes)
          .difference(current_data.pluck(:attributes))
          .map { |entity| Commands::AddAttribute.new(entity:, attribute: 'foo') }
      )
      .concat(
        current_data
          .pluck(:attributes)
          .difference(new_data.pluck(:attributes))
          .map { |entity| Commands::RemoveAttribute.new(entity:, attribute: 'foo') }
      )

    private

    def current_data
      @current_schema&.as_json || []
    end

    def new_data
      @new_schema&.as_json || []
    end
  end
end
