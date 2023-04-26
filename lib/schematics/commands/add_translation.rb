# frozen_string_literal: true

require 'rails/generators'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class AddTranslation < Command
      def generators = [translation_generator].compact

      def translation_generator
        return if core?

        TranslationGenerator.new([attribute])
      end

      def weight = 4
    end
  end
end
