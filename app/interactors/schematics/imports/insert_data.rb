# frozen_string_literal: true

module Schematics
  module Imports
    class InsertData
      include Interactor
      RECORD_NOT_UNIQUE_REGEX = /DETAIL:  Key \((.+)\)=\((.+)\) (.+)\.\n/
      delegate :model_name, to: :@model_class, private: true

      before do
        @import = context.import
        @model_class = context.model_class
        @data = context.data
      end

      def call
        record_ids = @model_class.insert_all!(@data).pluck('id') # rubocop:disable Rails/SkipsModelValidations
        Schematics::Version.insert_all(record_ids.map(&method(:version))) # rubocop:disable Rails/SkipsModelValidations
      rescue ActiveRecord::RecordNotUnique => e
        context.fail!(errors: { 'Error' => e.message.scan(RECORD_NOT_UNIQUE_REGEX).join(' ') }) # rubocop:disable Style/StringHashKeys
      end

      private

      def version(id)
        {
          item_type: model_name.to_s,
          item_id: id,
          event: 'import',
          whodunnit: @import.author.id,
          created_at: ::Time.current
        }
      end
    end
  end
end
