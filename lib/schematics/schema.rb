module Schematics
  class Schema
    include Singleton
    attr_accessor :entities, :charts, :stats
    delegate :validate, to: :schemer

    def initialize
      @entities = data[:entities].map { |entity| Entity.create(entity) }
      @charts = data[:charts].map { |chart| Chart.create(self, chart) }
      @stats = data[:stats].map { |stat| Stat.create(self, stat) }
      add_inverse_descriptor_to_references
      add_has_many_associations
      add_has_one_associations
      add_has_many_through_associations
      add_has_one_through_associations
    end

    def find_entity_by_type(type)
      @entities.find { |entity| entity.type === type }
    end

    def generate
      @entities.sort_by(&:weight).reverse.each(&:generate)
    end

    def to_s
      @entities.sort_by(&:weight).reverse.map(&:to_s).join("\n")
    end

    def valid?
      schemer.valid?(data)
    end

    private

    def schemer
      @schemer ||= JSONSchemer.schema(Pathname.new(File.expand_path("../schema.json", __dir__)))
    end

    def data
      @data ||= data_json.merge(app_json) { |key, left, right| left + right }
    end

    def app_json
      JSON.parse(File.read(File.expand_path("../app.json", __dir__)), symbolize_names: true)
    end

    def data_json
      JSON.parse(File.read(File.expand_path("../../test/data.json", __dir__)), symbolize_names: true)
    end

    def add_inverse_descriptor_to_references
      @entities.each do |entity|
        entity.references.each do |reference|
          reference.inverse_descriptor = find_entity_by_type(reference.association_type).descriptor
        end
      end
    end

    def add_has_many_associations
      @entities.each do |entity|
        entity.references.select(&:inverse_of_has_many?).each do |reference|
          find_entity_by_type(reference.association_type).has_many_associations << reference.create_inverse_association
        end
      end
    end

    def add_has_one_associations
      @entities.each do |entity|
        entity.references.select(&:inverse_of_has_one?).each do |reference|
          find_entity_by_type(reference.association_type).has_one_associations << reference.create_inverse_association
        end
      end
    end

    def add_has_many_through_associations
      @entities.each do |entity|
        entity.has_many_associations.each do |association|
          association.entity.has_many_associations.each do |has_many_association|
            if has_many_association.entity != association.entity # prevent self association
              association = Associations::HasManyThrough.new(has_many_association.reference, association)
              entity.has_many_through_associations << association
            end
          end
        end
      end
    end

    def add_has_one_through_associations
      @entities.each do |entity|
        entity.references.each do |reference|
          find_entity_by_type(reference.association_type).references.each do |parent_reference|
            if parent_reference.entity != reference.entity # prevent self association
              association = Associations::HasOneThrough.new(parent_reference, reference)
              entity.has_one_through_associations << association
            end
          end
        end
      end
    end
  end
end
