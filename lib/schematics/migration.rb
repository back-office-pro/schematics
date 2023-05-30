# frozen_string_literal: true

module Schematics
  # :reek:DataClump
  class Migration # rubocop:disable Metrics/ClassLength
    def initialize(new_schema, current_schema = nil)
      @new_schema = new_schema
      @current_schema = current_schema
    end

    def new_entities = build_commands
      .grep(Commands::CreateEntity)
      .concat(build_commands.grep(Commands::RenameEntity))
      .map(&:entity)
      .uniq

    def old_entities = clean_commands
      .grep(Commands::DestroyEntity)
      .concat(clean_commands.grep(Commands::RenameEntity))
      .map(&:entity)
      .uniq

    def changed_entities = build_commands
      .grep(Commands::RenameAttribute)
      .concat(build_commands.grep(Commands::ChangeAttribute))
      .concat(build_commands.grep(Commands::AddAttribute))
      .concat(clean_commands.grep(Commands::RemoveAttribute))
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

    def build_commands
      @new_schema.entities.map do |new_entity|
        current_entity = @current_schema&.entities&.find { _1.id == new_entity.id }
        next Commands::CreateEntity.new(entity: new_entity) unless current_entity

        [
          rename_entity_command(new_entity, current_entity, :build),
          add_permission_commands(new_entity, current_entity),
          rename_permission_commands(new_entity, current_entity),
          add_translation_commands(new_entity, current_entity),
          rename_translation_commands(new_entity, current_entity),
          add_association_commands(new_entity, current_entity),
          add_attribute_commands(new_entity, current_entity)
        ]
      end.flatten!.compact!.sort_by!(&:weight)
    end

    def clean_commands
      return [] unless @current_schema

      @current_schema.entities.map do |current_entity|
        new_entity = @new_schema.entities.find { _1.id == current_entity.id }
        next Commands::DestroyEntity.new(entity: current_entity) unless new_entity

        [
          rename_entity_command(current_entity, new_entity, :clean),
          remove_permission_commands(current_entity, new_entity),
          remove_attribute_commands(current_entity, new_entity),
          remove_translation_commands(current_entity, new_entity),
          remove_association_commands(current_entity, new_entity)
        ]
      end.flatten!.compact!.sort_by!(&:weight)
    end

    private

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

    def add_association_commands(entity, current_entity)
      entity
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)
        .map(&:association_type)
        .difference(current_entity.has_and_belongs_to_many_associations.reject(&:hidden?).map(&:association_type)) # rubocop:disable Layout/LineLength
        .map { |attribute| Commands::AddAssociation.new(entity:, attribute:) }
    end

    def remove_association_commands(entity, new_entity)
      entity
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)
        .map(&:association_type)
        .difference(new_entity.has_and_belongs_to_many_associations.reject(&:hidden?).map(&:association_type)) # rubocop:disable Layout/LineLength
        .map { |attribute| Commands::RemoveAssociation.new(entity:, attribute:) }
    end

    def add_attribute_commands(entity, current_entity)
      entity
        .attributes
        .map do |attribute|
          current_attribute = current_entity.attributes.find { _1.id == attribute.id }
          next Commands::AddAttribute.new(entity:, attribute: attribute.name) unless current_attribute # rubocop:disable Layout/LineLength

          [
            rename_attribute_command(entity, current_attribute, attribute),
            change_attribute_command(entity, current_attribute, attribute)
          ]
        end
    end
  end
end
