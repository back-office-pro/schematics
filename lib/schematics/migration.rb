# frozen_string_literal: true

module Schematics
  class Migration
    attr_reader :commands

    def initialize(current_schema, new_schema)
      @current_schema = current_schema
      @new_schema = new_schema
      @commands = []
      generate_migration_commands
    end

    private

    def generate_build_commmands # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      @new_schema.entities.reject(&:core?).each do |new_entity|
        current_entity = @current_schema.find_entity_by_id(new_entity.id)
        if current_entity
          if current_entity.name != new_entity.name
            @commands << Commands::RenameEntity.new(
              entity: new_entity,
              attribute: current_entity.name
            )
          end
          new_entity.attributes.each do |new_attribute|
            current_attribute = current_entity.find_attribute_by_id(new_attribute.id)
            if current_attribute
              if current_attribute.name != new_attribute.name
                @commands << Commands::RenameAttribute.new(
                  entity: new_entity,
                  attribute: new_attribute,
                  target: current_attribute.name
                )
              end
              if current_attribute.type != new_attribute.type
                @commands << Commands::ChangeAttribute.new(
                  entity: new_entity,
                  attribute: new_attribute
                )
              end
            else
              @commands << Commands::AddAttribute.new(
                entity: current_entity,
                attribute: new_attribute.name
              )
            end
          end
        else
          @commands << Commands::CreateEntity.new(entity: new_entity)
        end
      end
    end

    def generate_clean_commands
      @current_schema.entities.reject(&:core?).each do |current_entity|
        new_entity = @new_schema.find_entity_by_id(current_entity.id)
        if new_entity
          current_entity.attributes.each do |current_attribute|
            new_attribute = new_entity.find_attribute_by_id(current_attribute.id)
            next if new_attribute

            @commands << Commands::RemoveAttribute.new(
              entity: current_entity,
              attribute: current_attribute.name
            )
          end
        else
          @commands << Commands::DestroyEntity.new(entity: current_entity)
        end
      end
    end

    def generate_migration_commands
      generate_build_commmands
      generate_clean_commands
    end
  end
end
