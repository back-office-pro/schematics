# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Translatable
    extend ActiveSupport::Concern

    class_methods do
      def gender = [
        ::I18n.t(
          :gender,
          scope: [i18n_scope, :models, model_name.i18n_key],
          default: ::I18n.t('i18n.inflections.gender.default')
        ),
        ('vowel' if human_name.start_with?('a', 'e', 'i', 'o', 'u'))
      ].compact.join('_')

      def human_name(options = {})
        model_name
          .human(options)
          .humanize(capitalize: false)
      end

      def human_name_plural(options = {})
        human_name(**options, count: 2)
      end
    end
  end
end
