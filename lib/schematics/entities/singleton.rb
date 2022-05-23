# frozen_string_literal: true

module Schematics
  module Entities
    class Singleton < Entity
      def default_actions = %i[show update]

      def to_str = <<~RUBY
        include Schematics::Singleton
      RUBY
    end
  end
end
