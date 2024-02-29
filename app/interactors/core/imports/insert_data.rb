# frozen_string_literal: true

module Core
  module Imports
    class InsertData
      include Interactor

      RECORD_NOT_UNIQUE_REGEX = /Key \((.+)\)=\((.+)\)/

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, :model, :author, to: :import, private: true
      delegate :human_attribute_name, :insert_all!, to: :model_class, private: true

      # :reek:UncommunicativeVariableName
      def call
        record_ids = insert_all!(data).pluck('id') # rubocop:disable Rails/SkipsModelValidations
        Schematics::Version.insert_all(record_ids.map(&method(:paper_trail_version))) # rubocop:disable Rails/SkipsModelValidations
      rescue ActiveRecord::RecordNotUnique => e
        fail! errors: { 'Error' => record_not_unique(e) } # rubocop:disable Style/StringHashKeys
      end

      private

      def record_not_unique(exception)
        key, value = exception.message.scan(RECORD_NOT_UNIQUE_REGEX).flatten
        [human_attribute_name(key), value, ::I18n.t('errors.messages.taken')].join(' ')
      end

      def paper_trail_version(id)
        {
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
