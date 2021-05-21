# frozen_string_literal: true

require 'schematics/entities/entity'

module Schematics
  module Entities
    class Tree < Entity
      def to_str
        super + <<~RUBY # rubocop:disable Style/StringConcatenation
          has_ancestry
        RUBY
      end

      def viewer
        :tree
      end
    end
  end
end
