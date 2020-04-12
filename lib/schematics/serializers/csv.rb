module Schematics
  module Serializers
    class CSV < Serializer
      def serialize(separator: ',')
        ::CSV.generate(headers: true, col_sep: separator) do |file|
          file << headers
          @records.each do |record|
            @record = record
            file << fields +
                    belongs_to_attributes +
                    has_one_and_through_associations
          end
        end
      end

      def headers
        ((@entity.fields - @entity.belongs_to_attributes).select(&:visible?) +
          @entity.belongs_to_attributes +
          @entity.has_one_and_through_associations).
          map(&:name).map { |name| model.human_attribute_name(name) }
      end

      def fields
        (super - @entity.belongs_to_attributes).
          select(&:visible?).
          map { |field| field.format(@record.instance_eval(field.name)) }
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
