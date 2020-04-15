module Schematics
  module Serializers
    class CSV
      delegate_missing_to :@entity
      delegate :model, to: :@records

      def initialize(entity, records)
        @entity = entity
        @records = records
      end

      def to_csv(separator: ',')
        ::CSV.generate(headers: true, col_sep: separator) do |file|
          file << headers
          @records.each do |record|
            @record = record
            file << renderable_fields +
                    belongs_to_attributes +
                    has_one_and_through_associations
          end
        end
      end

      def to_xls
        to_csv(separator: '/t')
      end

      private

      def headers
        ((@entity.renderable_fields - @entity.belongs_to_attributes) +
          @entity.belongs_to_attributes +
          @entity.has_one_and_through_associations).
          map(&:name).map { |name| model.human_attribute_name(name) }
      end

      def renderable_fields
        (super - @entity.belongs_to_attributes).map do |field|
          Array.wrap(field.format(@record.instance_eval(field.name))).join(' ')
        end
      end

      def belongs_to_attributes
        super.map do |attribute|
          @record.instance_eval("#{attribute.name}.#{attribute.inverse_descriptor.name}")
        end
      end

      def has_one_and_through_associations
        super.map do |association|
          @record.instance_eval("#{association.name}.#{association.descriptor.name}")
        end
      end
    end
  end
end
