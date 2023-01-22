# frozen_string_literal: true

module Schematics
  module Retryable
    extend ActiveSupport::Concern

    class_methods do
      def transaction(**options, &)
        super
      rescue ActiveRecord::PreparedStatementCacheExpired
        retry # may happen after a column is changed
      end
    end
  end
end
