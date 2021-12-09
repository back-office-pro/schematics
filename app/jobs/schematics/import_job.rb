# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    def perform(import_id, model_name)
      import = Import.find(import_id)
      model_class = model_name.constantize
      result = Imports::ImportData.call(import:, model_class:)
      if result.success?
        import.status_finished!
        model_class.reindex
      else
        import.update!(status: 'error', import_errors: result.errors)
      end
    end
  end
end
