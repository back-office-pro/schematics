module Schematics
  class Schema
    include Singleton
    attr_accessor :entities, :charts, :stats
    delegate :schemer, to: :class

    class << self
      delegate :validate, to: :schemer

      def schemer
        @schemer ||= JSONSchemer.schema(Pathname.new(File.expand_path("../schema.json", __dir__)))
      end
    end

    def initialize
      @entities = data[:entities].map { |entity| Entity.create(entity) }
      @charts = data[:charts].map { |chart| Chart.create(self, chart) }
      @stats = data[:stats].map { |stat| Stat.create(self, stat) }
      add_inverse_descriptor_to_belongs_to_attributes
      add_has_many_associations
      add_has_one_associations
      add_has_many_through_associations
      add_has_one_through_associations
    end

    def find_entity_by_type(type)
      @entities.find { |entity| entity.type == type }
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

    def data
      @data ||= data_json.merge(app_json) { |key, left, right| left + right }
    end

    def app_json
      file_path = File.expand_path("../app.json", __dir__)
      file = File.read(file_path)
      JSON.parse(file, symbolize_names: true)
    end

    def data_json
      file_path = File.expand_path("../../spec/data.json", __dir__)
      file = File.read(file_path)
      JSON.parse(file, symbolize_names: true)
    end

    def add_inverse_descriptor_to_belongs_to_attributes
      @entities.each do |entity|
        entity.belongs_to_attributes.each do |attribute|
          attribute.inverse_descriptor = find_entity_by_type(attribute.association_type).descriptor
        end
      end
    end

    def add_has_many_associations
      @entities.each do |entity|
        entity.belongs_to_attributes.select(&:inverse_of_has_many?).each do |attribute|
          association = attribute.create_inverse_association
          find_entity_by_type(attribute.association_type).associations << association
        end
      end
    end

    def add_has_one_associations
      @entities.each do |entity|
        entity.belongs_to_attributes.select(&:inverse_of_has_one?).each do |attribute|
          association = attribute.create_inverse_association
          find_entity_by_type(attribute.association_type).associations << association
        end
      end
    end

    def add_has_many_through_associations
      @entities.each do |entity|
        entity.has_many_associations.each do |association|
          association.entity.has_many_associations.each do |has_many_association|
            if has_many_association.entity != association.entity # prevent self association
              has_many_through_association = Associations::HasManyThrough.new(
                has_many_association.belongs_to,
                association
              )
              entity.associations << has_many_through_association
            end
          end
        end
      end
    end

    def add_has_one_through_associations
      @entities.each do |entity|
        entity.belongs_to_attributes.each do |attribute|
          find_entity_by_type(attribute.association_type).belongs_to_attributes.each do |parent|
            if parent.entity != attribute.entity # prevent self association
              association = Associations::HasOneThrough.new(parent, attribute)
              entity.associations << association
            end
          end
        end
      end
    end
  end
end
