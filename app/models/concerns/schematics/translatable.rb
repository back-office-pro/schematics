# frozen_string_literal: true

module Schematics
  module Translatable
    extend ActiveSupport::Concern

    class_methods do
      def gender
        [
          ::I18n.t(:gender, scope: [i18n_scope, :models, model_name.i18n_key], default: 'male'),
          ('vowel' if human_name.start_with?('a', 'e', 'i', 'o', 'u'))
        ].compact.join('_')
      end

      def human_name(options = {})
        model_name
          .human(options)
          .downcase
      end

      def human_name_plural
        human_name.pluralize
      end
    end
  end
end
