# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Attributes
    class StateMachine < Enum
      def to_str
        super + <<~RUBY
          aasm column: :#{name}, no_direct_assignment: true, whiny_transitions: false do
            state :#{values.first}, initial: true
            state :#{values.drop(1).join(', :')}

          #{events_to_str}
          end
        RUBY
      end

      def icon
        :recycle
      end

      def readonly?
        true
      end

      def events
        options.events.map { StateMachineEvent.build(**_1) }
      end

      private

      def events_to_str
        events
          .join
          .indent(2)
          .chomp
      end
    end
  end
end
