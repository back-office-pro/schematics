# frozen_string_literal: true

module Core
  module Meetings
    class TodayQuery < Schematics::ApplicationQuery
      def call = where(start_at: Date.current.all_day)
    end
  end
end
