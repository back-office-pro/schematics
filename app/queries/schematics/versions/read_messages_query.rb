# frozen_string_literal: true

module Schematics
  module Versions
    class ReadMessagesQuery < ApplicationQuery
      def call = where(
        <<~SQL.squish
          paper_trail_versions.item_type = 'Message' AND
          paper_trail_versions.item_id = messages.id AND
          paper_trail_versions.event = 'show'
        SQL
      )
    end
  end
end
