# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    include Quietable
    queue_as :imports

    def perform(import)
      import.finalize!(Core::Imports::ImportData.call(import:).errors)
    end
  end
end
