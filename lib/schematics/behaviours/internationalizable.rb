# frozen_string_literal: true

module Schematics
  module Behaviours
    module Internationalizable
      def i18n_key
        [i18n_prefix, entity.name, name].join('.')
      end

      protected

      def i18n_prefix = :attributes
    end
  end
end
