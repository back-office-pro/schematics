# frozen_string_literal: true

module Schematics
  class Migration
    attr_reader :build_commands, :clean_commands

    def initialize(schema)
      @schema = schema
      @build_commands = []
      @clean_commands = []
      generate_build_commands
      generate_clean_commands
    end

    private

    def generate_build_commands # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      @schema.entities.reject(&:core?).each do |new_entity|
        current_entity = Schema.instance.find_entity_by_id(new_entity.id)
        if current_entity
          if current_entity.name != new_entity.name
            @build_commands << Commands::RenameEntity.new(
              entity: new_entity,
              attribute: current_entity.name
            )
          end
          new_entity.attributes.each do |new_attribute|
            current_attribute = current_entity.find_attribute_by_id(new_attribute.id)
            if current_attribute
              if current_attribute.name != new_attribute.name
                @build_commands << Commands::RenameAttribute.new(
                  entity: new_entity,
                  attribute: current_attribute.name,
                  target: new_attribute.name
                )
              end
              if current_attribute.type != new_attribute.type
                @build_commands << Commands::ChangeAttribute.new(
                  entity: new_entity,
                  attribute: new_attribute.name
                )
              end
            else
              @build_commands << Commands::AddAttribute.new(
                entity: new_entity,
                attribute: new_attribute.name
              )
            end
          end
        else
          @build_commands << Commands::CreateEntity.new(entity: new_entity)
          @build_commands << Commands::CreateEntityCounterCaches.new(entity: new_entity)
          @build_commands << Commands::CreateEntityPolymorphicCounterCaches.new(entity: new_entity)
        end
      end
      @build_commands.sort_by!(&:weight)
    end

    def generate_clean_commands
      Schema.instance.entities.reject(&:core?).each do |current_entity|
        new_entity = @schema.find_entity_by_id(current_entity.id)
        if new_entity
          current_entity.attributes.each do |current_attribute|
            new_attribute = new_entity.find_attribute_by_id(current_attribute.id)
            next if new_attribute

            @clean_commands << Commands::RemoveAttribute.new(
              entity: current_entity,
              attribute: current_attribute.name
            )
          end
        else
          @clean_commands << Commands::DestroyEntity.new(entity: current_entity)
        end
      end
      @clean_commands.sort_by!(&:weight)
    end
  end
end
