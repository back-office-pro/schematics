module Schematics
  class CsvSerializer
    delegate :klass, to: :@resources, private: true
    delegate :entity, to: :klass, private: true
    delegate :renderable_elements, to: :entity

    def initialize(resources)
      @resources = resources
    end

    def to_csv(separator: ',')
      CSV.generate(headers: true, col_sep: separator) do |file|
        file << headers
        @resources.each do |resource|
          file << renderable_elements_of(resource)
        end
      end
    end

    def to_xls
      to_csv(separator: '/t')
    end

    private

    def headers
      listable_elements
        .sort_by(&:weight)
        .map(&:name)
        .map { |name| klass.human_attribute_name(name) }
    end

    def renderable_elements_of(resource)
      listable_elements.sort_by(&:weight).map do |element|
        Array.wrap(element.format(resource.instance_eval(element.name))).join(' ')
      end
    end
  end
end
