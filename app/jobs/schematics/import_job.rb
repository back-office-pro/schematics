# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    def perform(import)
      result = Core::Imports::ImportData.call(import:)
      return import.update!(state: 'error', import_errors: result.errors) if result.failure?

      import
        .tap(&:state_finished!)
        .model_class
        .try(:reindex)
    end
  end
end
