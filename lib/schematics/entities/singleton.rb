# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def default = model_class.instance

      def default_actions = %i[show update]

      def id_attribute = super.tap { _1.options = { hidden: true } }

      def created_at_attribute = super.tap { _1.options = { hidden: true } }

      def to_str = super + <<~RUBY # rubocop:disable Style/StringConcatenation
        include Schematics::Singleton
      RUBY
    end
  end
end
