# frozen_string_literal: true

module MainApp
  module Message
    class UnreadQuery < Schematics::ApplicationQuery
      def call = where('NOT EXISTS (:version)', version: Schematics::Version.read_messages)
    end
  end
end
