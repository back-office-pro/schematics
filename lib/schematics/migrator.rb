# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  # :reek:DataClump
  class Migrator # rubocop:disable Metrics/ClassLength
    attr_reader :new_schema

    def initialize(new_schema = Schema.new, current_schema = nil)
      @new_schema = new_schema
      @current_schema = current_schema
    end

    def new_entities = build_commands
      .grep(Commands::CreateEntity)
      .concat(build_commands.grep(Commands::RenameEntity))
      .map(&:entity)

    def old_entities = clean_commands
      .grep(Commands::DestroyEntity)
      .map(&:entity)
      .concat(build_commands.grep(Commands::RenameEntity).map(&:attribute))

    def changed_entities = Array(
      @current_schema
        &.entities
        &.excluding(old_entities)
        &.reject do |current_entity|
          @new_schema
            .entities
            .find { _1.id == current_entity.id }
            .digest
            .eql?(current_entity.digest)
        end
    )

    def new_and_changed_entities = new_entities.concat(changed_entities)

    def old_and_changed_entities = old_entities.concat(changed_entities)

    def build_commands
      @new_schema.entities.map do |new_entity|
        current_entity = @current_schema&.entities&.find { _1.id == new_entity.id }
        next Commands::CreateEntity.new(entity: new_entity) unless current_entity

        [
          rename_entity_command(new_entity, current_entity),
          add_permission_commands(new_entity, current_entity),
          rename_permission_commands(new_entity, current_entity),
          add_translation_commands(new_entity, current_entity),
          rename_translation_commands(new_entity, current_entity),
          add_association_commands(new_entity, current_entity),
          add_attribute_commands(new_entity, current_entity)
        ]
      end.flatten.compact.sort_by(&:weight)
    end

    def clean_commands
      return [] unless @current_schema

      @current_schema.entities.map do |current_entity|
        new_entity = @new_schema.entities.find { _1.id == current_entity.id }
        next Commands::DestroyEntity.new(entity: current_entity) unless new_entity

        [
          remove_permission_commands(current_entity, new_entity),
          remove_attribute_commands(current_entity, new_entity),
          remove_translation_commands(current_entity, new_entity),
          remove_association_commands(current_entity, new_entity)
        ]
      end.flatten.compact.sort_by(&:weight)
    end

    private

    def rename_entity_command(entity, other_entity)
      return if entity.name == other_entity.name

      Commands::RenameEntity.new(entity:, attribute: other_entity)
    end

    def add_permission_commands(entity, current_entity)
      add_action_permission_commands(entity, current_entity) +
        add_event_permission_commands(entity, current_entity)
    end

    def add_action_permission_commands(entity, current_entity)
      entity
        .actions
        .difference(current_entity.actions)
        .map { |attribute| Commands::AddPermission.new(entity:, attribute:) }
    end

    # :reek:FeatureEnvy
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

    def rename_permission_command(entity, current_event, new_event)
      return unless current_event
      return if current_event.name == new_event.name

      Commands::RenamePermission.new(
        entity:,
        attribute: current_event.name,
        target: new_event.name
      )
    end

    def add_translation_commands(entity, current_entity)
      %i[virtuals events enum_values].flat_map do |items|
        entity
          .public_send(items)
          .reject { |item| current_entity.public_send(items).find { _1.id == item.id } }
          .map { |attribute| Commands::AddTranslation.new(entity:, attribute:) }
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
              item
            )
          end
      end
    end

    def rename_translation_command(entity, current_item, new_item)
      return unless current_item
      return if current_item.name == new_item.name

      Commands::RenameTranslation.new(entity:, attribute: current_item, target: new_item)
    end

    def add_association_commands(entity, current_entity)
      associations = current_entity.non_hidden_has_and_belongs_to_many_associations
      entity
        .non_hidden_has_and_belongs_to_many_associations
        .reject { |association| associations.find { _1.association_type == association.association_type } } # rubocop:disable Layout/LineLength
        .map { |attribute| Commands::AddAssociation.new(entity:, attribute:) }
    end

    def add_attribute_commands(entity, current_entity)
      entity
        .attributes
        .map do |attribute|
          current_attribute = current_entity.attributes.find { _1.id == attribute.id }
          next Commands::AddAttribute.new(entity:, attribute:) unless current_attribute

          [
            rename_attribute_command(entity, current_attribute, attribute),
            change_attribute_command(entity, current_attribute, attribute),
            change_attribute_uniqueness_command(entity, current_attribute, attribute)
          ]
        end
    end

    def rename_attribute_command(entity, current_attribute, new_attribute)
      return if current_attribute.name == new_attribute.name

      Commands::RenameAttribute.new(entity:, attribute: current_attribute, target: new_attribute)
    end

    def change_attribute_command(entity, current_attribute, new_attribute)
      return if current_attribute.database_type == new_attribute.database_type

      Commands::ChangeAttribute.new(entity:, attribute: new_attribute, target: current_attribute)
    end

    def change_attribute_uniqueness_command(entity, current_attribute, new_attribute)
      return if current_attribute.unique? == new_attribute.unique?

      Commands::ChangeAttributeUniqueness.new(entity:, attribute: new_attribute)
    end

    def remove_permission_commands(entity, new_entity)
      remove_action_permission_commands(entity, new_entity) +
        remove_event_permission_commands(entity, new_entity)
    end

    def remove_action_permission_commands(entity, new_entity)
      entity
        .actions
        .difference(new_entity.actions)
        .map { |attribute| Commands::RemovePermission.new(entity:, attribute:) }
    end

    # :reek:FeatureEnvy
    def remove_event_permission_commands(entity, new_entity)
      entity
        .events
        .reject { |event| new_entity.events.find { _1.id == event.id } }
        .map { |event| Commands::RemovePermission.new(entity:, attribute: event.name) }
    end

    def remove_attribute_commands(entity, new_entity)
      entity
        .attributes
        .reject { |attribute| new_entity.attributes.find { _1.id == attribute.id } }
        .map { |attribute| Commands::RemoveAttribute.new(entity:, attribute:) }
    end

    def remove_translation_commands(entity, new_entity)
      %i[virtuals events enum_values].flat_map do |items|
        entity
          .public_send(items)
          .reject { |item| new_entity.public_send(items).find { _1.id == item.id } }
          .map { |attribute| Commands::RemoveTranslation.new(entity:, attribute:) }
      end
    end

    def remove_association_commands(entity, new_entity)
      associations = new_entity.non_hidden_has_and_belongs_to_many_associations
      entity
        .non_hidden_has_and_belongs_to_many_associations
        .reject { |association| associations.find { _1.association_type == association.association_type } } # rubocop:disable Layout/LineLength
        .map { |attribute| Commands::RemoveAssociation.new(entity:, attribute:) }
    end
  end
end
