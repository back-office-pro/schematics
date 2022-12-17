# frozen_string_literal: true

module Schematics
  module Versions
    class UnreadQuery < ApplicationQuery
      def call(read_notifications_at)
        where(created_at: read_notifications_at...)
      end
    end
  end
end
