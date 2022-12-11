# frozen_string_literal: true

module Schematics
  module Migrations
    class Migration
      attr_reader :build_commands, :clean_commands

      def initialize(new_entities = [], current_entities = [])
        @new_entities = new_entities
        @current_entities = current_entities
        @build_commands = []
        @clean_commands = []
        generate_build_commands
        generate_clean_commands
      end

      def new_entities = @build_commands
        .select_is_a?(Commands::CreateEntity)
        .map(&:entity)

      def old_entities = @clean_commands
        .select_is_a?(Commands::DestroyEntity)
        .map(&:entity)

      private

      def generate_build_commands # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        @new_entities.each do |new_entity|
          current_entity = @current_entities.find { _1.id == new_entity.id }
          if current_entity
            if current_entity.name != new_entity.name
              @build_commands << Commands::RenameEntity.new(
                entity: new_entity,
                attribute: current_entity.name,
                target: :build
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
                if current_attribute.database_type != new_attribute.database_type
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
            @build_commands << Commands::CreateEntityPolymorphicCounterCaches.new(entity: new_entity) # rubocop:disable Layout/LineLength
          end
        end
        @build_commands.sort_by!(&:weight)
      end

      def generate_clean_commands
        @current_entities.each do |current_entity|
          new_entity = @new_entities.find { _1.id == current_entity.id }
          if new_entity
            if new_entity.name != current_entity.name
              @clean_commands << Commands::RenameEntity.new(
                entity: current_entity,
                attribute: new_entity.name,
                target: :clean
              )
            end
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
end
