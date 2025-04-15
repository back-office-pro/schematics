# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module I18n
  module Backend
    class RouteTranslator
      include Base
      include Memoize

      PREFIXES = %w[
        activerecord.models.
        activerecord.models.schematics/
        activerecord.models.active_storage/
        activemodel.models.schematics/
      ].freeze

      delegate :available_locales, to: 'Rails.configuration.i18n'

      def lookup(locale, key, scope = [], _options = EMPTY_HASH)
        case [scope, key]
        in [:routes, model]
          PREFIXES
            .filter_map { resolve(locale, nil, :"#{it}#{model.to_s.singularize}.other", default: nil) } # rubocop:disable Layout/LineLength
            .first
            &.parameterize
        else
          nil
        end
      end
    end
  end
end
