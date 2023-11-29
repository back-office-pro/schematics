# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    queue_as :imports

    def perform(import)
      PaperTrail.request(enabled: false) do
        import.finalize! Core::Imports::ImportData.call(import:).errors
      end
    end
  end
end
