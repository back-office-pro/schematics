# frozen_string_literal: true

module MainApp
  module Session
    class ActiveQuery < Schematics::ApplicationQuery
      def call
        where(updated_at: ACTIVE_DELAY.ago..).load_async
      end
    end
  end
end
