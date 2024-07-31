# frozen_string_literal: true

module Schematics
  class GenerateSchemaJob < ApplicationJob
    include Quietable

    retry_on Faraday::Error, wait: :polynomially_longer, attempts: 5
    retry_on ActiveRecord::RecordInvalid, wait: 10.seconds, attempts: 5

    def perform(migration)
      migration.update!(::Migration::GATEWAY::Chat.call(migration:).to_h.slice(:data))
    end
  end
end
