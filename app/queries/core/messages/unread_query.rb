# frozen_string_literal: true

module Core
  module Messages
    class UnreadQuery < Schematics::ApplicationQuery
      def call = where(
        'NOT EXISTS (:paper_trail_version)',
        paper_trail_version: Schematics::Version.read_messages
      )
    end
  end
end
