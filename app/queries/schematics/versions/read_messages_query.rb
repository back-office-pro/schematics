# frozen_string_literal: true

module Schematics
  module Versions
    class ReadMessagesQuery < ApplicationQuery
      def call = where(
        <<~SQL.squish
          versions.item_type = 'Message' AND
          versions.item_id = messages.id AND
          versions.event = 'show'
        SQL
      )
    end
  end
end
