# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Sessions
    class ActiveQuery < Schematics::ApplicationQuery
      def call
        where(updated_at: ::Session::ACTIVE_DELAY.ago..).load_async
      end
    end
  end
end
