# frozen_string_literal: true

module Schematics
  module Behaviours
    module Untranslatable
      def available_options = super.excluding(Options::Translated)

      def translated? = false
    end
  end
end
