# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Attributes
    class StateMachine < Enum
      delegate :direct_assignment, to: :options

      def available_options = super.push(
        Options::Events,
        Options::DirectAssignment
      )

      def icon = :recycle

      def readonly? = true

      def to_str = super
        .concat <<~RUBY
          aasm column: :#{name}, enum: true, no_direct_assignment: #{!direct_assignment} do
            state :#{values.first}, initial: true
            state :#{values.drop(1).join(', :')}
          #{events_to_str}
          end
          #{events_methods_to_str}
        RUBY

      def events
        options.events&.map { StateMachineEvent.new(entity:, **_1) } || []
      end

      private

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
