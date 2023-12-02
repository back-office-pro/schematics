# frozen_string_literal: true

require 'rails/generators'
require 'generators/translation/translation_generator'

module Schematics
  module Commands
    class RenameTranslation < Command
      def generators = [translation_generator].compact

      def translation_generator
        return if core?

        TranslationGenerator.new([target], ["--rename=#{attribute}"], behavior: :revoke)
      end

      def weight = 3
    end
  end
end
