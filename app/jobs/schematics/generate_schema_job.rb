# frozen_string_literal: true

module Schematics
  class GenerateSchemaJob < ApplicationJob
    include Quietable
    queue_as :migrations

    retry_on Faraday::Error, wait: :polynomially_longer, attempts: 5
    retry_on ActiveRecord::RecordInvalid, wait: 10.seconds, attempts: 5

    after_perform { _1.arguments.first.state_editing! }

    def perform(migration)
      return if migration.processing?

      migration.state_generating!
      migration.update!(::Migration::GATEWAY::Chat.call(migration:).to_h.slice(:data))
    end
  end
end
