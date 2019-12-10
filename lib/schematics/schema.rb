module Schematics
  class Schema
    attr_accessor :entities

    def initialize(filename)
      @file = File.read(filename)
      @data = JSON.parse(@file, symbolize_names: true)
      @entities = @data.map { |type, entity| Entity.create(type, entity) }
      add_has_many_associations
      add_has_one_associations
      add_has_many_through_associations
      add_has_one_through_associations
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
              entity.has_many_through_associations << Associations::HasManyThrough.new(has_many_association.reference, association)
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
              entity.has_one_through_associations << Associations::HasOneThrough.new(parent_reference, reference)
            end
          end
        end
      end
    end

    def find_entity_by_type(type)
      @entities.find { |entity| entity.type === type }
    end
    
    def find_descriptor_by_reference(reference)
      find_entity_by_type(reference.association_type).descriptor
    end

    def generate
      @entities.sort_by(&:weight).reverse.each(&:generate)
    end

    def print
      @entities.sort_by(&:weight).reverse.map(&:print)
    end
  end
end
