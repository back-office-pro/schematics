# frozen_string_literal: true

module Core
  module Migrations
    class ProcessingQuery < Schematics::ApplicationQuery
      def call = state_in_progress
        .or(state_rollbacking)
        .or(state_generating)
    end
  end
end
