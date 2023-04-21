# frozen_string_literal: true

require 'rails/generators'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RenameTranslation < Command
      def generators = [
        TranslationGenerator.new([target], ["--rename=#{attribute}"], behavior: :revoke)
      ]

      def weight = 4
    end
  end
end
