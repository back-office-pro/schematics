# frozen_string_literal: true

require 'action_view'

module Schematics
  module Attributes
    # :reek:Attribute :reek:InstanceVariableAssumption
    class StateMachineEvent
      include ::ActiveModel::API
      include ::ActionView::Helpers::TranslationHelper

      delegate :to_str, to: :trigger, prefix: true
      attr_accessor :entity, :name, :from, :to, :callback
      attr_writer :icon

      def icon
        @icon&.to_sym || :location_arrow
      end

      def human
        translate(
          name.to_sym,
          default: name.humanize,
          scope: [:activerecord, :events, entity.name]
        )
      end

      def to_str = <<~RUBY
        event :#{name}, after_commit: :#{action} do
          transitions from: #{Array(from).map(&:to_sym)}, to: :#{to}
        end
      RUBY

      private

      def action = "after_#{name}"

      def trigger
        @trigger ||= Trigger.new(action:, callback:)
      end
    end
  end
end
