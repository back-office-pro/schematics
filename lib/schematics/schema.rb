# frozen_string_literal: true

require 'singleton'
require 'active_model'

module Schematics
  # :reek:InstanceVariableAssumption
  class Schema # rubocop:disable Metrics/ClassLength
    include ::Singleton
    include ::ActiveModel::API
    attr_reader :entities

    class << self
      public :new
      delegate :load, to: :new

      def dump(data)
        data.to_json
      end
    end

    def initialize = load

    def load(data = [])
      return unless data

      data = ::JSON.parse(data) if data.is_a?(::String)
      @data = data.map(&:deep_symbolize_keys)
      self.entities = core_data.concat(@data)
      self
    end

    def as_json = @data

    def entities=(entities)
      @entities = entities.map { Entities::Entity.build(**_1) }
      add_associations_and_check_for_name_collisions
    end

    alias entities_attributes= entities=

    def find_entity_by_name(name)
      entities.find { _1.name == name }
    end

    def find_entity_by_id(id)
      entities.find { _1.id == id }
    end

    def find_attribute_by_prefixed_name(name)
      entities
        .flat_map(&:attributes)
        .find { _1.prefixed_name == name }
    end

    def load_routes
      context = binding.of_caller(2).method(:eval)
      entities
        .map(&Entities::Router.method(:new))
        .each(&context)
    end

    def polymorphic_associations = entities
      .flat_map(&:association_attributes)
      .select(&:polymorphic?)

    def root_route
      return 'dashboard#home' if valid?

      'exception#schema_error'
    end

    def valid?(*)
      valid = super && entities.all?(&:valid?)
      entities.each { errors.merge!(_1) }
      valid
    end

    private

    def core_data = ::JSON
      .parse(File.read(File.expand_path('../core.json', __dir__)), symbolize_names: true)
      .tap { |json| json.each { _1[:options]&.store(:core, true) } }

    def add_associations_and_check_for_name_collisions
      add_inverse_entity_to_association_attributes
      add_inverse_entity_to_polymorphic_association_attributes
      add_has_and_belongs_to_many_associations
      add_inverse_associations
      add_has_many_through_associations
      add_has_one_through_associations
      add_inverse_polymorphic_associations
      entities.each(&:check_for_association_name_collisions)
    end

    def add_inverse_entity_to_association_attributes = entities
      .flat_map(&:association_attributes)
      .reject(&:polymorphic?)
      .each do |attribute|
        attribute.inverse_entity = find_entity_by_name(attribute.association_type)
      end

    def add_inverse_entity_to_polymorphic_association_attributes
      polymorphic_associations.each do |attribute|
        attribute.inverse_entity = entities.first
      end
    end

    # :reek:FeatureEnvy
    def add_has_and_belongs_to_many_associations = entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .each do |habtm|
        find_entity_by_name(habtm.name.singularize)
          .associations
          .push(
            Associations::Association.build(
              entity: habtm.entity,
              name: habtm.entity.name,
              type: 'has_and_belongs_to_many'
            )
          )
      end

    def add_inverse_associations = entities
      .flat_map(&:association_attributes)
      .reject(&:polymorphic?)
      .map(&:inverse_association)
      .each do |association|
        find_entity_by_name(association.association_type)
          .associations
          .push(association)
      end

    def add_inverse_polymorphic_associations
      entities.each do |entity|
        entity
          .associations
          .push(*polymorphic_associations.map(&:inverse_association))
      end
    end

    def add_has_many_through_associations
      entities.each do |entity|
        entity.has_many_associations.each do |parent|
          find_has_many_through_associations(entity, parent)
        end
      end
    end

    # :reek:FeatureEnvy
    def find_has_many_through_associations(entity, parent)
      parent.entity.has_many_associations.each do |child|
        next if child.entity == parent.entity # prevent self association

        entity.associations << Associations::HasManyThrough.new(
          belongs_to: child.belongs_to,
          through: parent
        )
        find_has_many_through_associations(entity, child)
      end
    end

    def add_has_one_through_associations
      entities.each do |entity|
        entity
          .association_attributes
          .reject(&:polymorphic?)
          .each { |parent| find_has_one_through_associations(entity, parent) }
      end
    end

    def find_has_one_through_associations(entity, parent)
      find_entity_by_name(parent.association_type).association_attributes.each do |child|
        next if child.entity == parent.entity # prevent self association

        entity.associations << Associations::HasOneThrough.new(belongs_to: child, through: parent)
        find_has_one_through_associations(entity, child)
      end
    end
  end
end
