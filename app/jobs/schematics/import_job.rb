# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    include Quietable

    queue_as :default

    discard_on ActiveStorage::FileNotFoundError

    after_discard do |job|
      PaperTrail.request(enabled: false) do
        suppress(ActiveRecord::RecordNotFound) do
          job.arguments.first.reload.state_error!
        end
      end
    end

    def perform(import)
      return unless import.state_pending?

      I18n.with_locale(import.locale) do
        import.state_in_progress!
        import.finalize!(Core::Imports::ImportData.call(import:).errors)
      end
    end
  end
end
