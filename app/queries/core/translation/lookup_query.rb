# frozen_string_literal: true

module Core
  module Translation
    class LookupQuery < Schematics::ApplicationQuery
      def call(locale, key)
        where(locale:)
          .where('key ~* ?', "#{key}(\\.|$)")
          .pluck(:key, :value)
          .to_h
      end
    end
  end
end
