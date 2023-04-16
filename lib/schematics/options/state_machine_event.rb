# frozen_string_literal: true

require 'action_view'

module Schematics
  module Options
    # :reek:Attribute :reek:InstanceVariableAssumption
    class StateMachineEvent
      include ::ActiveModel::API
      include ::ActionView::Helpers::TranslationHelper
      include Behaviours::Identifiable

      validates :from, :to, inclusion: { in: :values }
      validates :name,
                presence: true,
                format: { with: Entities::Entity::NAME_REGEX, message: :name }

      delegate :to_str, to: :trigger, prefix: true
      delegate :entity, :values, to: :state_machine

      attr_accessor :state_machine, :name, :from, :to, :callback
      attr_writer :icon, :color

      def icon
        @icon&.to_sym || :location_arrow
      end

      def color
        @color&.to_sym || :primary
      end

      def action = :"after_#{name}"

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

      def trigger
        @trigger ||= Trigger.new(action:, callback:)
      end
    end
  end
end
