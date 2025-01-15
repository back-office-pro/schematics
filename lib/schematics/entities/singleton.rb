# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      DEFAULT_ACTIONS = %i[show update].freeze

      def id_attribute = super.tap { it.options = { hidden: true } }

      def created_at_attribute = super.tap { it.options = { hidden: true } }

      def model_elements = super.push <<~RUBY
        include Schematics::Singleton
      RUBY
    end
  end
end
