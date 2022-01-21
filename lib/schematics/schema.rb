# frozen_string_literal: true

require 'json-schema'
require 'singleton'

module Schematics
  class Schema
    include Singleton
    attr_reader :entities, :migrations

    def initialize
      @entities = data[:entities].map { Entities::Entity.build(**_1) }
      @migrations = data[:migrations]&.map { Migration.build(self, **_1) }
      add_inverse_entity_to_association_attributes
      add_has_and_belongs_to_many_associations
      add_inverse_associations
      add_has_many_through_associations
      add_has_one_through_associations
      @entities.each(&:check_for_association_name_collisions)
    end

    def find_entity_by_name(name)
      @entities.find { _1.name == name }
    end

    def find_attribute_by_id(id)
      @entities
        .flat_map(&:attributes)
        .find { _1.id == id }
    end

    def load_routes
      context = binding.of_caller(2).method(:eval)
      sorted_entities
        .map(&Entities::Router.method(:new))
        .each(&context)
    end

    def to_s
      sorted_entities
        .map(&:to_s)
        .join("\n")
    end

    def sorted_entities
      @entities
        .sort_by(&:weight)
        .reverse
    end

    def root_route
      return 'dashboard#home' if valid?

      'exception#schema_error'
    end

    def valid?
      JSON::Validator.validate(File.expand_path('../schema.json', __dir__), data)
    end

    def data
      @data ||= data_json.merge(app_json) { |_key, left, right| left + right }
    end

    def app_json
      JSON
        .parse(File.read(File.expand_path('../app.json', __dir__)), symbolize_names: true)
        .tap do |json|
          json[:entities].each { _1[:core] = true }
        end
    end

    def data_json
      JSON.parse(
        File.read(File.expand_path('../../spec/data.json', __dir__)),
        symbolize_names: true
      )
    end

    private

    def add_inverse_entity_to_association_attributes
      @entities
        .flat_map(&:association_attributes)
        .reject(&:polymorphic?)
        .each do |attribute|
          attribute.inverse_entity = find_entity_by_name(attribute.association_type)
        end
    end

    def add_has_and_belongs_to_many_associations
      @entities
        .flat_map(&:has_and_belongs_to_many_associations)
        .each do |habtm|
          find_entity_by_name(habtm.name.singularize)
            .associations
            .push(
              Associations::Association.build(
                habtm.entity,
                name: habtm.entity.name,
                type: 'has_and_belongs_to_many'
              )
            )
        end
    end

    def add_inverse_associations
      @entities
        .flat_map(&:association_attributes)
        .reject(&:polymorphic?)
        .map(&:inverse_association)
        .each do |association|
          find_entity_by_name(association.association_type)
            .associations
            .push(association)
        end
    end

    def add_has_many_through_associations
      @entities.each do |entity|
        entity.has_many_associations.each do |parent|
          find_has_many_through_associations(entity, parent)
        end
      end
    end

    def find_has_many_through_associations(entity, parent)
      parent.entity.has_many_associations.each do |child|
        next if child.entity == parent.entity # prevent self association

        entity.associations << Associations::HasManyThrough.new(child.belongs_to, parent)
        find_has_many_through_associations(entity, child)
      end
    end

    def add_has_one_through_associations
      @entities.each do |entity|
        entity
          .association_attributes
          .reject(&:polymorphic?)
          .each { |parent| find_has_one_through_associations(entity, parent) }
      end
    end

    def find_has_one_through_associations(entity, parent)
      find_entity_by_name(parent.association_type).association_attributes.each do |child|
        next if child.entity == parent.entity # prevent self association

        entity.associations << Associations::HasOneThrough.new(child, parent)
        find_has_one_through_associations(entity, child)
      end
    end
  end
end
