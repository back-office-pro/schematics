module Schematics
  class CsvSerializer
    delegate_missing_to :entity
    delegate :model, to: :@records
    delegate :entity, to: :model

    def initialize(records)
      @records = records
    end

    def to_csv(separator: ',')
      CSV.generate(headers: true, col_sep: separator) do |file|
        file << headers
        @records.each do |record|
          @record = record
          file << renderable_fields + renderable_associations
        end
      end
    end

    def to_xls
      to_csv(separator: '/t')
    end

    private

    def headers
      ((entity.renderable_fields - entity.association_attributes) +
        entity.association_attributes +
        entity.renderable_associations).
        map(&:name).map { |name| model.human_attribute_name(name) }
    end

    def renderable_fields
      (super - association_attributes).map do |field|
        Array.wrap(field.format(@record.instance_eval(field.name))).join(' ')
      end
    end

    def renderable_associations
      (association_attributes + super).map do |association|
        @record.instance_eval(association.name)
      end
    end
  end
end
