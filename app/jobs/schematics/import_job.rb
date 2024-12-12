# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    include Quietable
    queue_as :imports

    discard_on ActiveStorage::FileNotFoundError

    def perform(import)
      return unless import.state_pending?

      I18n.with_locale(import.locale) do
        import.state_in_progress!
        import.finalize!(Core::Imports::ImportData.call(import:).errors)
      end
    end
  end
end
