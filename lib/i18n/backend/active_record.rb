# frozen_string_literal: true

module I18n
  module Backend
    class ActiveRecord
      include Base
      include Memoize

      delegate :available_locales, to: 'Rails.configuration.i18n'
      delegate :normalize_flat_keys, to: '::I18n::Backend::Flatten'

      def lookup(locale, key, scope = [], options = EMPTY_HASH)
        key = normalize_flat_keys(locale, key, scope, '.')
        case key.split('.')
        in ['activerecord', 'models', *]
          fetch(locale, key + count_to_key(options[:count]))
        in ['routes', *] | ['activerecord', 'attributes', *] | ['activerecord', 'events', *]
          fetch(locale, key)
        end
      rescue StandardError
        nil
      end

      private

      # :reek:NilCheck
      def count_to_key(count)
        return '' if count.nil?
        return '.zero' if count.zero?
        return '.one' if count == 1
        return '.other' if count > 1
      end

      def fetch(locale, key)
        Rails.cache.fetch("i18n:#{locale}:#{key}") do
          ::Translation.where(locale:, key:).pick(:value)
        end
      end
    end
  end
end
