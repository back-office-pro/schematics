# frozen_string_literal: true

module Core
  module Messages
    class ReadQuery < Schematics::ApplicationQuery
      def call
        joins(:versions).where(versions: { event: 'show' })
      end
    end
  end
end
