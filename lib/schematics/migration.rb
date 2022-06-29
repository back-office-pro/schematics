# frozen_string_literal: true

module Schematics
  class Migration
    def initialize(current_schema, new_schema)
      @current_schema = current_schema
      @new_schema = new_schema
    end

    def commands # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      migration_commands = []
      new_data.each_with_index do |entity, entity_index|
        current_entity = @current_schema.find_entity_by_name(entity[:name])
        new_entity = @new_schema.find_entity_by_name(entity[:name])
        if current_data[entity_index].nil?
          migration_commands << Commands::CreateEntity.new(entity: new_entity)
          next
        elsif current_entity.nil?
          migration_commands << Commands::RenameEntity.new(
            entity: new_entity,
            attribute: entity[:name]
          )
        end
        entity[:attributes].each_with_index do |attribute, attribute_index|
          current_attribute = current_entity&.find_field_by_name(attribute[:name])
          new_attribute = new_entity.find_field_by_name(attribute[:name])
          if current_data.dig(entity_index, :attributes, attribute_index).nil?
            migration_commands << Commands::AddAttribute.new(
              entity: current_entity,
              attribute: attribute[:name]
            )
          elsif current_entity && current_attribute.nil?
            migration_commands << Commands::RenameAttribute.new(
              entity: new_entity,
              attribute: new_attribute,
              target: attribute[:name]
            )
          end
        end
      end
      current_data.each_with_index do |entity, entity_index|
        current_entity = @current_schema.find_entity_by_name(entity[:name])
        if new_data[entity_index].nil?
          migration_commands << Commands::DestroyEntity.new(entity: current_entity)
          next
        end
        entity[:attributes].each_with_index do |attribute, attribute_index|
          next if new_data.dig(entity_index, :attributes, attribute_index)

          migration_commands << Commands::RemoveAttribute.new(
            entity: current_entity,
            attribute: attribute[:name]
          )
        end
      end
      migration_commands
    end

    private

    def current_data
      @current_schema&.as_json || []
    end

    def new_data
      @new_schema&.as_json || []
    end
  end
end
