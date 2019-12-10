module Schematics
  module Serializers
    class CSV < Serializer
      def serialize(records, separator = ',')
        eager_loading(records)
        ::CSV.generate(headers: true, col_sep: separator) do |file|
          file << @entity.attributes.map(&:name).map(&:humanize)
          records.each do |record|
            file << attributes.map { |field| field.render(record) }
          end
        end
      end

      def eager_loading(records)
        records = records.includes(@entity.references.map(&:name).map(&:to_sym)) unless @entity.references.empty?
      end
    end
  end
end
