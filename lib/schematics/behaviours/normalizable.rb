# frozen_string_literal: true

module Schematics
  module Behaviours
    module Normalizable
      delegate :normalization, to: :options

      def available_options = super.push(Options::Normalization)

      def to_str = super + <<~RUBY
        normalizes :#{name}, with: -> { _1.strip.#{normalization || :itself} }
      RUBY
    end
  end
end
