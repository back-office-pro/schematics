# frozen_string_literal: true

module I18n
  module Backend
    class ActiveRecord
      include Base
      include Memoize

      delegate :available_locales, to: 'Rails.configuration.i18n'

      def lookup(locale, key, scope = [], options = EMPTY_HASH)
        key = Flatten.normalize_flat_keys(locale, key, scope, '.')
        case key.split('.')
        in ['activerecord', 'models', *]
          fetch(locale, key + count_to_key(options[:count]))
        in ['activerecord', 'attributes', *] | ['activerecord', 'events', *]
          fetch(locale, key)
        else
          nil
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
        Rails.cache.fetch("translations/#{locale}/#{key}") do
          format_lookup ::Translation.lookup(locale, key), key
        end
      end

      def format_lookup(translations, key)
        return if translations.empty?
        return translations.values.first if translations.size == 1

        translations
          .transform_keys { _1.delete_prefix("#{key}.") }
          .flatten_to_nested
      end
    end
  end
end
