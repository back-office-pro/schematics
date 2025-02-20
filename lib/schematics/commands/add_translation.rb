# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/generators'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class AddTranslation < Command
      def generators = [translation_generator].compact

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute.i18n_key])
      end

      def weight = 3
    end
  end
end
