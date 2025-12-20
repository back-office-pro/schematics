# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateSchemaJob < ApplicationJob
    include Quietable

    queue_as :critical

    discard_on Faraday::UnauthorizedError

    retry_on Faraday::Error, wait: :polynomially_longer, attempts: 5
    retry_on ActiveRecord::RecordInvalid, wait: 10.seconds, attempts: 5 do |_job, error|
      Rollbar.error('[Migration] GenerateSchema error', data: error.record.data.to_json)
    end

    after_discard do |job|
      PaperTrail.request(enabled: false) do
        suppress(ActiveRecord::RecordNotFound) do
          job.arguments.first.reload.state_no_solution!
        end
      end
    end

    def perform(migration)
      return if migration.state_pending?
      return if migration.state_in_progress?
      return if migration.state_rollbacking?

      I18n.with_locale(migration.locale) do
        migration.state_generating!
        migration.update!(::Migration::GATEWAY::Chat.call(migration:).to_h.slice(:data))
        migration.state_editing!
      end
    end
  end
end
