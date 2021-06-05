# frozen_string_literal: true

module Schematics
  module Resources
    class BulkInsert
      include Interactor

      before do
        @file = context.file
        @model_class = context.model_class
        @current_user = context.current_user
        @importer = CsvImporter.new(@file, @model_class, @current_user)
      end

      def call
        case @importer.import
        when :ok
          context.message = '.success'
        when :content_type_error
          context.fail!(message: '.failure')
        when :import_error
          context.errors = @importer.errors
          context.fail!(message: '.failure')
        end
      end
    end
  end
end
