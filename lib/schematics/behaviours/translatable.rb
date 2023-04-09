# frozen_string_literal: true

module Schematics
  module Behaviours
    module Translatable
      include Preloadable
      AVAILABLES_LOCALES = %i[en fr].freeze
      delegate :translated?, to: :options

      def preload
        return unless translated?

        :string_translations
      end

      def permitted_params
        return super unless translated?

        AVAILABLES_LOCALES.map { :"#{name}_#{_1}" }
      end

      def to_str
        return super unless translated?

        super + <<~RUBY
          translates :#{name}
        RUBY
      end
    end
  end
end
