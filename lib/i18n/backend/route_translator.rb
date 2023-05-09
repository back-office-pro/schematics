# frozen_string_literal: true

module I18n
  module Backend
    class RouteTranslator
      include Base
      include Memoize

      delegate :available_locales, to: ::I18n

      def lookup(locale, key, scope = [], _options = EMPTY_HASH)
        case [scope, key]
        in [:routes, model]
          resolve(locale, nil, :"activerecord.models.#{model.singularize}.other", default: nil)
            &.gsub(/\b\w{1,2}\b/, '')
            &.parameterize(separator: '-')
        else
          nil
        end
      end
    end
  end
end
