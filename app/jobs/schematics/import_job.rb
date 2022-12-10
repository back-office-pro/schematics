# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    def perform(import)
      result = Imports::ImportData.call(import:)
      if result.success?
        import.status_finished!
      else
        import.update!(status: 'error', import_errors: result.errors)
      end
    end
  end
end
