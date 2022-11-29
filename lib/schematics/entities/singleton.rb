# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def default
        model_class.instance
      end

      def default_actions = %i[show update]

      def id_attribute = super.tap { _1.options = { hidden: true } }

      def created_at_attribute = super.tap { _1.options = { hidden: true } }

      def to_str = <<~RUBY
        include Schematics::Singleton
      RUBY
    end
  end
end
