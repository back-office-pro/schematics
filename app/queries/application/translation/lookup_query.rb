# frozen_string_literal: true

module Application
  module Translation
    class LookupQuery < Schematics::ApplicationQuery
      def call(locale, key)
        where(locale:)
          .where('key LIKE ?', "#{key}%")
          .pluck(:key, :value)
          .to_h
          .transform_keys { _1.split('.').last }
          .symbolize_keys
      end
    end
  end
end
