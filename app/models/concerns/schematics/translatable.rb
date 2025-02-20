# Copyright © 2025 Dev & Software. All rights reserved.
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
