# frozen_string_literal: true

module Schematics
  class GenerateSchemaJob < ApplicationJob
    include Quietable

    def perform(migration)
      migration.update!(::Migration::GATEWAY::Chat.call(migration:).to_h.slice(:data))
    end
  end
end
