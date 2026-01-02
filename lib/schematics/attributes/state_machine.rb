# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Attributes
    class StateMachine < Enum
      delegate :direct_assignment, to: :options
      validates_associated :events

      def available_options = super
        .excluding(Options::Readonly)
        .push(Options::Events, Options::DirectAssignment)

      def icon = :recycle

      def readonly? = true

      def to_str = super + <<~RUBY.squeeze("\n")
        aasm :#{name}, column: :#{name}, enum: true, namespace: :#{name}, create_scopes: false, no_direct_assignment: #{!direct_assignment} do
        #{states_to_str}
        #{events_to_str}
        end
        #{events_methods_to_str}
      RUBY

      memoize def events = Array(
        options
          .events
          &.each_with_object(state_machine: self)
          &.map(&:merge)
          &.map(&Options::StateMachineEvent)
      )

      private

      def states_to_str = values
        .map
        .with_index { |value, index| ["state :#{value}", ('initial: true' if index.zero?)] }
        .map(&:compact)
        .map { _1.join(', ').indent(2) }
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
