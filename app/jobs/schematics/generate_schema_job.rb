# frozen_string_literal: true

module Schematics
  class GenerateSchemaJob < ApplicationJob
    include Quietable

    def perform(migration)
      migration.update!(data: ::Migration::GATEWAY::Chat.call(migration:).data)
    end
  end
end
