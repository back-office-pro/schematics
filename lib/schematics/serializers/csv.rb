module Schematics
  module Serializers
    class CSV < Serializer
      def serialize(records, separator = ',')
        super(records)
        ::CSV.generate(headers: true, col_sep: separator) do |file|
          file << fields.map(&:name).map(&:humanize)
          records.each do |record|
            @record = record
            file << attributes +
              virtuals +
              references +
              has_one_associations +
              has_one_through_associations
          end
        end
      end

      def fields
        @entity.attributes.select(&:visible?) -
        @entity.references +
        @entity.virtuals +
        @entity.references +
        @entity.has_one_associations +
        @entity.has_one_through_associations
      end

      def attributes
        super.map { |attribute| attribute.format(@record.instance_eval(attribute.name)) }
      end

      def virtuals
        super.map { |virtual| virtual.format(@record.instance_eval(virtual.name)) }
      end

      def references
        super.map do |reference|
          @record.instance_eval("#{reference.name}.#{reference.inverse_descriptor.name}")
        end
      end

      def has_one_associations
        super.map(&method(:has_associations))
      end

      def has_one_through_associations
        super.map(&method(:has_associations))
      end

      def has_associations(association)
        @record.instance_eval("#{association.name}.#{association.descriptor.name}")
      end
    end
  end
end
