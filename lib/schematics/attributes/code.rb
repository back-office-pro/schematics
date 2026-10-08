# frozen_string_literal: true

module Schematics
  module Attributes
    class Code < Text
      include Behaviours::Unnormalizable

      delegate :language, to: :options

      def available_options = super.push(Options::Language)

      def openai_description = 'An attribute which represents a source code'

      def icon = :code
    end
  end
end
