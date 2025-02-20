# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Behaviours
    module Normalizable
      delegate :normalization, to: :options

      def available_options = super.push(Options::Normalization)

      def to_str
        return super if entity.existing?

        super + <<~RUBY
          normalizes :#{name}, with: -> { it.strip.#{normalization || :itself}.presence }
        RUBY
      end
    end
  end
end
