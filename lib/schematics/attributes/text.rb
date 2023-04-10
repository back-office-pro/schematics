# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Preloadable
      include Behaviours::Translatable

      def available_options = super.push(
        Options::Translated
      )

      def default = SecureRandom.base58

      def icon = :font
    end
  end
end
