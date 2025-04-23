# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'
require 'singleton'

module Schematics
  # :reek:InstanceVariableAssumption
  class Schema
    include ::ActiveModel::API
    include ::ActiveModel::NestedAttributes

    accepts_nested_attributes_for :entities
    validates_associated :entities
    attr_reader :entities, :version

    class << self
      def load(data)
        new(data:) if data
      end

      def dump(data)
        data.to_json
      end
    end

    def initialize(data: [], version: VERSION)
      data = ::JSON.parse(data) if data in ::String
      @data = data.map(&:deep_symbolize_keys)
      @version = version
      self.entities = core_data.concat(@data)
    end

    def as_json = @data

    def entities=(entities)
      @entities = entities
                  .each_with_object(schema: self)
                  .map(&:merge)
                  .map(&Entities::Entity)
      add_associations_and_check_for_name_collisions
    end

    def find_entity_by_name(name)
      entities.find { _1.name == name }
    end

    def polymorphic_associations = entities
      .flat_map(&:association_attributes)
      .select(&:polymorphic?)

    def model_classes = entities
      .reject(&:core?)
      .filter_map(&:model_class)

    private

    def core_data = ::JSON
      .parse(File.read(core_data_filepath), symbolize_names: true)
      .tap { |json| json.each { _1[:options]&.store(:core, true) } }

    def core_data_filepath = File.expand_path(File.join('versions', "#{version}.json"), __dir__)

    def add_associations_and_check_for_name_collisions
      add_has_and_belongs_to_many_associations
      add_inverse_associations
      add_has_many_through_associations
      add_has_one_through_associations
      add_inverse_polymorphic_associations
    end

    # :reek:FeatureEnvy
    def add_has_and_belongs_to_many_associations = entities
      .flat_map(&:has_and_belongs_to_many_associations)
      .select(&:inverse_entity)
      .each { _1.inverse_entity.associations << _1.inverse_association }

    # :reek:FeatureEnvy
    def add_inverse_associations = entities
      .flat_map(&:association_attributes)
      .reject(&:polymorphic?)
      .select(&:inverse_entity)
      .each { _1.inverse_entity.associations << _1.inverse_association }

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
        next if child.association_type == parent.entity.name # prevent infinite loop

        find_has_many_through_associations(entity, child)
      end
    end

    def add_has_one_through_associations
      entities.each do |entity|
        entity
          .association_attributes
          .reject(&:polymorphic?)
          .select(&:inverse_entity)
          .each(&method(:find_has_one_through_associations).curry.call(entity))
      end
    end

    def add_inverse_polymorphic_associations
      entities.each do |entity|
        entity
          .associations
          .push(*polymorphic_associations.map(&:inverse_association))
      end
    end

    # :reek:FeatureEnvy
    def find_has_one_through_associations(entity, parent)
      parent.inverse_entity.association_attributes.reject(&:polymorphic?).each do |child|
        next if child.entity == parent.entity # prevent self association

        entity.associations << Associations::HasOneThrough.new(belongs_to: child, through: parent)
        next if parent.inverse_entity == child.entity # prevent infinite loop

        find_has_one_through_associations(entity, child)
      end
    end
  end
end
