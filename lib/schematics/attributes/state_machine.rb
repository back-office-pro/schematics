# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Attributes
    class StateMachine < Enum
      def icon = :recycle

      def readonly? = true

      def to_str = super
        .concat <<~RUBY
          aasm column: :#{name}, enum: true, no_direct_assignment: true do
            state :#{values.first}, initial: true
            state :#{values.drop(1).join(', :')}
          #{events_to_proc}
          end
          #{events_to_str}
        RUBY

      def events
        options.events.map { StateMachineEvent.new(entity:, **_1) }
      end

      private

      def events_to_str = events
        .join
        .chomp

      def events_to_proc = events
        .map(&:to_proc)
        .join
        .indent(2)
        .chomp
    end
  end
end
