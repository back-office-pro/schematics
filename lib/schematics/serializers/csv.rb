module Schematics
  module Serializers
    class CSV < Serializer
      def serialize(separator: ',')
        ::CSV.generate(headers: true, col_sep: separator) do |file|
          file << headers
          @records.each do |record|
            @record = record
            file << fields_without_references + references + has_one_and_through_associations
          end
        end
      end

      def headers
        (@entity.fields_without_references.select(&:visible?) +
          @entity.references +
          @entity.has_one_and_through_associations
        ).map(&:name).map { |name| model.human_attribute_name(name) }
      end

      def fields_without_references
        super.select(&:visible?).map { |field| field.format(@record.instance_eval(field.name)) }
      end

      def references
        super.map do |reference|
          @record.instance_eval("#{reference.name}.#{reference.inverse_descriptor.name}")
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
