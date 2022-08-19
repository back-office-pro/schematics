# frozen_string_literal: true

module I18n
  module Backend
    class ActiveRecord
      include Base
      include Memoize
      include Pluralization

      delegate :available_locales, to: 'Rails.configuration.i18n'
      delegate :normalize_flat_keys, to: '::I18n::Backend::Flatten'

      def lookup(locale, key, scope = [], _options = EMPTY_HASH)
        key = normalize_flat_keys(locale, key, scope, '.')
        Rails.cache.fetch("i18n:#{locale}:#{key}") do
          ::Translation.where(locale:, key:).pick(:value)
        end
      rescue StandardError
        nil
      end
    end
  end
end
