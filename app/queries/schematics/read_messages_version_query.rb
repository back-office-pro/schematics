# frozen_string_literal: true

module Schematics
  class ReadMessagesVersionQuery < ApplicationQuery
    def call = where(
      <<~SQL.squish
        versions.item_type = 'Message' AND
        versions.item_id = messages.id AND
        versions.event = 'show'
      SQL
    )

    protected

    def model_class = Version
  end
end
