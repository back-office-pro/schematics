# frozen_string_literal: true

module Schematics
  module Attributes
    class StateMachineEvent
      attr_reader :name, :icon, :to

      class << self
        def build(name:, from:, to:, icon: :location_arrow)
          new(name, icon, from, to)
        end
      end

      def initialize(name, icon, from, to)
        @name = name
        @icon = icon
        @from = from
        @to = to
      end

      def to_str
        <<~RUBY
          event :#{@name} do
            transitions from: #{Array(@from).map(&:to_sym)}, to: :#{@to}
          end
        RUBY
      end
    end
  end
end
