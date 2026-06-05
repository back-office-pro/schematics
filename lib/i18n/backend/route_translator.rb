# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
