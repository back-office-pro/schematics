# frozen_string_literal: true

module Core
  module Imports
    class InsertData
      include Schematics::Progressable

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, :model, :author, to: :import, private: true
      delegate :human_attribute_name,
               :insert_all,
               :generate_ulid,
               to: :model_class,
               private: true

      progressable import: 100

      def call
        record_ids = insert_all(data).pluck('id') # rubocop:disable Rails/SkipsModelValidations
        Schematics::Version.insert_all(record_ids.map(&method(:paper_trail_version))) # rubocop:disable Rails/SkipsModelValidations
      end

      private

      def paper_trail_version(id)
        {
          id: generate_ulid,
          item_type: model,
          item_id: id,
          event: 'import',
          whodunnit: author.id,
          created_at: ::Time.current
        }
      end
    end
  end
end
