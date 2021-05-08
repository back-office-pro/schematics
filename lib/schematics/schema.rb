require 'schematics/entities/entity'
require 'schematics/entities/tree'
require 'schematics/entities/singleton'
require 'schematics/graphics/chart'
require 'schematics/graphics/stat'
require 'json_schemer'
require 'singleton'

module Schematics
  class Schema
    include Singleton
    delegate :schemer, to: :class, private: true
    attr_reader :entities, :charts, :stats

    class << self
      delegate :validate, to: :schemer, private: true

      def schemer
        @schemer ||= JSONSchemer.schema(Pathname.new(File.expand_path('../schema.json', __dir__)))
      end
    end

    def initialize
      @entities = data[:entities].map { |entity| Entities::Entity.create(**entity) }
      @charts = data[:charts].map { |chart| Graphics::Chart.create(self, **chart) }
      @stats = data[:stats].map { |stat| Graphics::Stat.create(self, **stat) }
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
      routes.each(&context)
    end

    def generate
      @entities
        .sort_by(&:weight)
        .reverse
        .flat_map(&:generators)
        .each(&method(:system))
    end

    def to_s
      @entities
        .sort_by(&:weight)
        .reverse
        .map(&:to_s)
        .join("\n")
    end

    def valid?
      schemer.valid?(data)
    end

    private

    def data
      @data ||= data_json.merge(app_json) { |_key, left, right| left + right }
    end

    def app_json
      file_path = File.expand_path('../app.json', __dir__)
      file = File.read(file_path)
      JSON.parse(file, symbolize_names: true)
    end

    def data_json
      file_path = File.expand_path('../../spec/data.json', __dir__)
      file = File.read(file_path)
      JSON.parse(file, symbolize_names: true)
    end

    def routes
      @entities
        .sort_by(&:weight)
        .reverse
        .map(&:route)
    end

    def add_inverse_entity_to_association_attributes
      @entities.each do |entity|
        entity.association_attributes.each do |attribute|
          attribute.inverse_entity = find_entity_by_name(attribute.association_type)
        end
      end
    end

    def add_has_and_belongs_to_many_associations
      @entities.flat_map(&:has_and_belongs_to_many_associations).each do |habtm|
        association = Associations::Association.create(
          habtm.entity,
          name: habtm.entity.name,
          type: 'has_and_belongs_to_many'
        )
        find_entity_by_name(habtm.name.singularize).associations << association
      end
    end

    def add_inverse_associations
      @entities.each do |entity|
        entity.association_attributes.map(&:inverse_association).each do |association|
          find_entity_by_name(association.association_type).associations << association
        end
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
        entity.association_attributes.each do |parent|
          find_has_one_through_associations(entity, parent)
        end
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
