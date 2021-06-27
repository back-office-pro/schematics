# frozen_string_literal: true

module Schematics
  module Imports
    class InsertData
      include Interactor
      delegate :model_name, to: :@model_class, private: true
      REGEX = /DETAIL:  Key \((.+)\)=\((.+)\) (.+)\.\n/

      before do
        @import = context.import
        @model_class = context.model_class
        @data = context.data
      end

      # rubocop:disable Rails/SkipsModelValidations
      def call
        record_ids = @model_class.insert_all!(@data).pluck('id')
        Schematics::Version.insert_all(record_ids.map(&method(:version)))
      rescue ActiveRecord::RecordNotUnique => e
        context.fail!(errors: { 'Error' => e.message.scan(REGEX).join(' ') })
      end
      # rubocop:enable Rails/SkipsModelValidations

      private

      def version(id)
        {
          item_type: model_name.to_s,
          item_id: id,
          event: 'import',
          whodunnit: @import.author.id,
          created_at: Time.current
        }
      end
    end
  end
end
