# frozen_string_literal: true

module Application
  module ApiKey
    class ActiveQuery < Schematics::ApplicationQuery
      def call = where(expires_at: nil)
        .or(where(expires_at: ::Time.current..))
        .load_async
    end
  end
end
