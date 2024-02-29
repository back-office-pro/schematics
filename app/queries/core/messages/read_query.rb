# frozen_string_literal: true

module Core
  module Messages
    class ReadQuery < Schematics::ApplicationQuery
      def call
        joins(:paper_trail_versions).where(paper_trail_versions: { event: 'show' })
      end
    end
  end
end
