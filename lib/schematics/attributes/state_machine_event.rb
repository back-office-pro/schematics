# frozen_string_literal: true

require 'action_view'

module Schematics
  module Attributes
    class StateMachineEvent
      include ActionView::Helpers::TranslationHelper

      attr_reader :name, :icon

      def initialize(entity:, name:, from:, to:, icon: :location_arrow)
        @entity = entity
        @name = name
        @icon = icon
        @from = from
        @to = to
      end

      def human
        translate(
          name.to_sym,
          default: name.humanize,
          scope: [:activerecord, :events, @entity.name]
        )
      end

      def to_str
        <<~RUBY
          def after_#{@name}; end
        RUBY
      end

      def to_proc
        <<~RUBY
          event :#{@name}, after: :after_#{@name} do
            transitions from: #{Array(@from).map(&:to_sym)}, to: :#{@to}
          end
        RUBY
      end
    end
  end
end
