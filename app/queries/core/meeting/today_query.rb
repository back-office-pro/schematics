# frozen_string_literal: true

module Core
  module Meeting
    class TodayQuery < Schematics::ApplicationQuery
      def call = where("DATE(#{table_name}.start_at) = ?", Date.current)
    end
  end
end
