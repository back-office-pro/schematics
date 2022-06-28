# frozen_string_literal: true

module Schematics
  class Migration
    def initialize(current_schema, new_schema)
      @current_schema = current_schema
      @new_schema = new_schema
    end

    def commands = new_data
      .difference(current_data)
      .map { |name: nil| @new_schema.find_entity_by_name(name) }
      .map { |entity| Commands::CreateEntity.new(entity:) }
      .concat(
        current_data
          .difference(new_data)
          .map { |name: nil| @current_schema.find_entity_by_name(name) }
          .map { |entity| Commands::DestroyEntity.new(entity:) }
      )
      .concat(
        new_data_attributes
          .difference(current_data_attributes)
          .map { |entity| Commands::AddAttribute.new(entity:, attribute: 'foo') }
      )
      .concat(
        current_data_attributes
          .difference(new_data_attributes)
          .map { |entity| Commands::RemoveAttribute.new(entity:, attribute: 'foo') }
      )

    private

    def current_data
      @current_schema&.as_json || []
    end

    def current_data_attributes
      current_data.pluck(:attributes)
    end

    def new_data
      @new_schema&.as_json || []
    end

    def new_data_attributes
      new_data.pluck(:attributes)
    end
  end
end
