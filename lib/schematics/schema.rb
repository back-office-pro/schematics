module Schematics
  class Schema
    include Singleton
    attr_reader :entities, :charts, :stats
    delegate :schemer, to: :class, private: true

    class << self
      delegate :validate, to: :schemer, private: true

      def schemer
        @schemer ||= JSONSchemer.schema(Pathname.new(File.expand_path("../schema.json", __dir__)))
      end
    end

    def initialize
      @entities = data[:entities].map { |entity| Entities::Entity.create(entity) }
      @charts = data[:charts].map { |chart| Graphics::Chart.create(self, chart) }
      @stats = data[:stats].map { |stat| Graphics::Stat.create(self, stat) }
      add_inverse_descriptor_to_association_attributes
      add_has_many_associations
      add_has_one_associations
      add_has_many_through_associations
      add_has_one_through_associations
    end

    def find_entity_by_name(name)
      @entities.find { |entity| entity.name == name }
    end

    def load_routes
      context = binding.of_caller(2).method(:eval)
      routes.each(&context)
    end

    def generate
      @entities.sort_by(&:weight).reverse.map(&:generate).flatten.each(&method(:system))
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

    def routes
      @entities.sort_by(&:weight).reverse.map(&:route)
    end

    def add_inverse_descriptor_to_association_attributes
      @entities.each do |entity|
        entity.association_attributes.each do |attribute|
          attribute.inverse_descriptor = find_entity_by_name(attribute.association_type).descriptor
        end
      end
    end

    def add_has_many_associations
      @entities.each do |entity|
        entity.association_attributes.select(&:inverse_of_has_many?).each do |attribute|
          association = attribute.create_inverse_association
          find_entity_by_name(attribute.association_type).associations << association
        end
      end
    end

    def add_has_one_associations
      @entities.each do |entity|
        entity.association_attributes.select(&:inverse_of_has_one?).each do |attribute|
          association = attribute.create_inverse_association
          find_entity_by_name(attribute.association_type).associations << association
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
        if child.entity != parent.entity # prevent self association
          entity.associations << Associations::HasManyThrough.new(child.belongs_to, parent)
          find_has_many_through_associations(entity, child)
        end
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
        if child.entity != parent.entity # prevent self association
          entity.associations << Associations::HasOneThrough.new(child, parent)
          find_has_one_through_associations(entity, child)
        end
      end
    end
  end
end
