module Schematics
  class Schema
    include Singleton
    attr_accessor :entities, :charts, :stats

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

    private

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

    def app_data_file_path
      File.expand_path("../app.json", __dir__)
    end

    def app_data_file
      File.read(app_data_file_path)
    end

    def app_json_data_file
      JSON.parse(app_data_file, symbolize_names: true)
    end

    def data_file_path
      "/Users/max/bitbucket/schematics/test/data.json"
    end

    def data_file
      File.read(data_file_path)
    end

    def json_data_file
      JSON.parse(data_file, symbolize_names: true)
    end

    def data
      @data ||= json_data_file.merge(app_json_data_file) { |key, left, right| left + right }
    end
  end
end
