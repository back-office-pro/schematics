# frozen_string_literal: true

require 'rails/generators'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class AddTranslation < Command
      def generators = [
        TranslationGenerator.new([attribute])
      ]

      def weight = 4
    end
  end
end
