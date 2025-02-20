# Copyright © 2025 Dev & Software. All rights reserved.
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
        in ['activerecord', 'attributes', *] | ['activerecord', 'enums', *] | ['activerecord', 'events', *] # rubocop:disable Layout/LineLength
          fetch(locale, key)
        else
          nil
        end
      end

      private

      def fetch(locale, key)
        suppress(StandardError) do
          Rails.cache.fetch("translations/#{locale}/#{key}/value") do
            format_lookup ::Translation.lookup(locale, key), key
          end
        end
      end

      # :reek:FeatureEnvy
      def format_lookup(translations, key)
        return if translations.empty?
        return translations.values.first if translations.size == 1

        translations
          .transform_keys { it.delete_prefix("#{key}.") }
          .flatten_to_nested
      end

      def count_to_key(count)
        return '' unless count
        return '.zero' if count.zero?
        return '.one' if count == 1

        '.other' if count > 1
      end
    end
  end
end
