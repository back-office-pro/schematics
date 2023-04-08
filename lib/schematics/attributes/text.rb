# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def default = SecureRandom.base58

      def icon = :font

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def format(value)
        value&.to_s
      end
    end
  end
end
