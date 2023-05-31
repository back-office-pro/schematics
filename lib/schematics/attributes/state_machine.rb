# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Attributes
    class StateMachine < Enum
      delegate :direct_assignment, to: :options
      validates_associated :events

      def available_options = super.push(
        Options::Events,
        Options::DirectAssignment
      )

      def icon = :recycle

      def readonly? = true

      def to_str = super + <<~RUBY.squeeze("\n")
        aasm column: :#{name}, enum: true, no_direct_assignment: #{!direct_assignment} do
          state :#{values.first}, initial: true
        #{states_to_str}
        #{events_to_str}
        end
        #{events_methods_to_str}
      RUBY

      def events
        @events ||= Array(
          options
            .events
            &.map { Options::StateMachineEvent.new(state_machine: self, **_1) }
        )
      end

      private

      def states_to_str = values
        .drop(1)
        .map { "state :#{_1}".indent(2) }
        .join("\n")

      def events_to_str = events
        .join
        .indent(2)
        .chomp

      def events_methods_to_str = events
        .map(&:trigger_to_str)
        .join
        .chomp
    end
  end
end
