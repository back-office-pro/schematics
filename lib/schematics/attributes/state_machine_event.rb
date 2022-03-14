# frozen_string_literal: true

require 'action_view'

module Schematics
  module Attributes
    class StateMachineEvent
      include ActionView::Helpers::TranslationHelper

      delegate :to_str, to: :trigger
      attr_reader :name, :icon

      # :reek:LongParameterList
      def initialize(entity:, name:, from:, to:, icon: :location_arrow, callback: nil) # rubocop:disable Metrics/ParameterLists
        @entity = entity
        @name = name
        @icon = icon
        @from = from
        @to = to
        @callback = callback
      end

      def human
        translate(
          name.to_sym,
          default: name.humanize,
          scope: [:activerecord, :events, @entity.name]
        )
      end

      def to_proc
        <<~RUBY
          event :#{@name} do
            transitions from: #{Array(@from).map(&:to_sym)}, to: :#{@to}, after: :after_#{@name}
          end
        RUBY
      end

      private

      def trigger
        @trigger ||= Trigger.new(action: @name, callback: @callback)
      end
    end
  end
end
