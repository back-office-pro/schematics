# frozen_string_literal: true

module Schematics
  module Behaviours
    module Translatable
      include Preloadable
      AVAILABLES_LOCALES = %i[en fr].freeze
      delegate :translated?, to: :options

      def preload
        return unless translated?

        :"#{translatable_type}_translations"
      end

      def permitted_params
        return super unless translated?

        AVAILABLES_LOCALES
          .map { :"#{name}_#{_1}" }
          .unshift(super)
      end

      def to_str
        return super unless translated?

        super + <<~RUBY
          translates :#{name}, type: :#{translatable_type}
        RUBY
      end

      def translatable_type = 'text'
    end
  end
end
