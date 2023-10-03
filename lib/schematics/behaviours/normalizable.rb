# frozen_string_literal: true

module Schematics
  module Behaviours
    module Normalizable
      def to_str = super + <<~RUBY
        normalizes :#{name}, with: -> { _1.strip }
      RUBY
    end
  end
end
