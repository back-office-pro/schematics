# frozen_string_literal: true

module Schematics
  module Migrations
    # :reek:DataClump
    class Migration # rubocop:disable Metrics/ClassLength
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
        .grep(Commands::CreateEntity)
        .concat(@build_commands.grep(Commands::RenameEntity))
        .map(&:entity)
        .uniq

      def old_entities = @clean_commands
        .grep(Commands::DestroyEntity)
        .concat(@clean_commands.grep(Commands::RenameEntity))
        .map(&:entity)
        .uniq

      def changed_entities = @build_commands
        .grep(Commands::RenameAttribute)
        .concat(@build_commands.grep(Commands::ChangeAttribute))
        .concat(@build_commands.grep(Commands::AddAttribute))
        .concat(@clean_commands.grep(Commands::RemoveAttribute))
        .map(&:entity)
        .excluding(new_entities)
        .excluding(old_entities)
        .uniq

      def new_and_changed_entities = new_entities
        .concat(changed_entities)
        .uniq

      def old_and_changed_entities = old_entities
        .concat(changed_entities)
        .uniq

      private

      def generate_build_commands
        @new_entities.each do |new_entity|
          current_entity = @current_entities.find { _1.id == new_entity.id }
          if current_entity
            @build_commands.push(
              rename_entity_command(new_entity, current_entity, :build),
              add_permission_commands(new_entity, current_entity),
              rename_permission_commands(new_entity, current_entity),
              add_translation_commands(new_entity, current_entity),
              rename_translation_commands(new_entity, current_entity)
            )
            new_entity.attributes.each do |new_attribute|
              current_attribute = current_entity.attributes.find { _1.id == new_attribute.id }
              if current_attribute
                @build_commands.push(
                  rename_attribute_command(new_entity, current_attribute, new_attribute),
                  change_attribute_command(new_entity, current_attribute, new_attribute)
                )
              else
                @build_commands << Commands::AddAttribute.new(
                  entity: new_entity,
                  attribute: new_attribute.name
                )
              end
            end
          else
            @build_commands << Commands::CreateEntity.new(entity: new_entity)
          end
        end
        @build_commands.flatten!
        @build_commands.compact!
        @build_commands.sort_by!(&:weight)
      end

      def generate_clean_commands
        @current_entities.each do |current_entity|
          new_entity = @new_entities.find { _1.id == current_entity.id }
          if new_entity
            @clean_commands.push(
              rename_entity_command(current_entity, new_entity, :clean),
              remove_permission_commands(current_entity, new_entity),
              remove_attribute_commands(current_entity, new_entity),
              remove_translation_commands(current_entity, new_entity)
            )
          else
            @clean_commands << Commands::DestroyEntity.new(entity: current_entity)
          end
        end
        @clean_commands.flatten!
        @clean_commands.compact!
        @clean_commands.sort_by!(&:weight)
      end

      def change_attribute_command(entity, current_attribute, new_attribute)
        return if current_attribute.database_type == new_attribute.database_type

        Commands::ChangeAttribute.new(
          entity:,
          attribute: new_attribute.name,
          target: current_attribute.database_type
        )
      end

      def rename_attribute_command(entity, current_attribute, new_attribute)
        return if current_attribute.name == new_attribute.name

        Commands::RenameAttribute.new(
          entity:,
          attribute: current_attribute.name,
          target: new_attribute.name
        )
      end

      def rename_entity_command(entity, other_entity, target)
        return if entity.name == other_entity.name

        Commands::RenameEntity.new(entity:, attribute: other_entity.name, target:)
      end

      def remove_attribute_commands(entity, new_entity)
        entity
          .attributes
          .reject { |attribute| new_entity.attributes.find { _1.id == attribute.id } }
          .map { |attribute| Commands::RemoveAttribute.new(entity:, attribute: attribute.name) }
      end

      def add_action_permission_commands(entity, current_entity)
        entity
          .actions
          .difference(current_entity.actions)
          .map { |attribute| Commands::AddPermission.new(entity:, attribute:) }
      end

      def remove_action_permission_commands(entity, new_entity)
        entity
          .actions
          .difference(new_entity.actions)
          .map { |attribute| Commands::RemovePermission.new(entity:, attribute:) }
      end

      def rename_permission_command(entity, current_event, new_event)
        return unless current_event
        return if current_event.name == new_event.name

        Commands::RenamePermission.new(
          entity:,
          attribute: current_event.name,
          target: new_event.name
        )
      end

      def remove_event_permission_commands(entity, new_entity)
        entity
          .events
          .reject { |event| new_entity.events.find { _1.id == event.id } }
          .map { |event| Commands::RemovePermission.new(entity:, attribute: event.name) }
      end

      def add_event_permission_commands(entity, current_entity)
        entity
          .events
          .reject { |event| current_entity.events.find { _1.id == event.id } }
          .map { |event| Commands::AddPermission.new(entity:, attribute: event.name) }
      end

      def rename_permission_commands(entity, current_entity)
        entity
          .events
          .map do |event|
            rename_permission_command(
              entity,
              current_entity.events.find { _1.id == event.id },
              event
            )
          end
      end

      def add_permission_commands(entity, current_entity)
        add_action_permission_commands(entity, current_entity) +
          add_event_permission_commands(entity, current_entity)
      end

      def remove_permission_commands(entity, new_entity)
        remove_action_permission_commands(entity, new_entity) +
          remove_event_permission_commands(entity, new_entity)
      end

      def add_translation_commands(entity, current_entity)
        %i[virtuals events].flat_map do |items|
          entity
            .public_send(items)
            .reject { |item| current_entity.public_send(items).find { _1.id == item.id } }
            .map do |item|
              Commands::AddTranslation.new(
                entity:,
                attribute: [items, entity.name, item.name].join('.')
              )
            end
        end
      end

      def rename_translation_commands(entity, current_entity)
        %i[virtuals events].flat_map do |items|
          entity
            .public_send(items)
            .map do |item|
              rename_translation_command(
                entity,
                current_entity.public_send(items).find { _1.id == item.id },
                item,
                items
              )
            end
        end
      end

      def rename_translation_command(entity, current_item, new_item, items)
        return unless current_item
        return if current_item.name == new_item.name

        Commands::RenameTranslation.new(
          entity:,
          attribute: [items, entity.name, current_item.name].join('.'),
          target: [items, entity.name, new_item.name].join('.')
        )
      end

      def remove_translation_commands(entity, new_entity)
        %i[virtuals events].flat_map do |items|
          entity
            .public_send(items)
            .reject { |item| new_entity.public_send(items).find { _1.id == item.id } }
            .map do |item|
              Commands::RemoveTranslation.new(
                entity:,
                attribute: [items, entity.name, item.name].join('.')
              )
            end
        end
      end
    end
  end
end
