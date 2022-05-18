# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def to_str = <<~RUBY
        include Schematics::Singleton
      RUBY

      protected

      def default_actions = %w[show update]
    end
  end
end
