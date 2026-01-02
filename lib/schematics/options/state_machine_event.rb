# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'action_view'
require 'active_support/core_ext/array/conversions'

module Schematics
  module Options
    # :reek:Attribute :reek:InstanceVariableAssumption
    class StateMachineEvent
      include ::ActiveModel::API
      include ::ActionView::Helpers::TranslationHelper
      include Behaviours::Internationalizable
      include Behaviours::Specifiable
      include Behaviours::Nameable

      COLORS = %i[primary secondary success danger warning].freeze

      validates :from, :to, presence: true, inclusion: { in: :values }
      validates :name, uniqueness: { scope: %i[state_machine events] }
      validates :icon, inclusion: { in: Icon.collection }
      validates :color, inclusion: { in: COLORS }

      delegate :to_str, to: :trigger, prefix: true
      delegate :entity, :values, to: :state_machine
      delegate :name, to: :state_machine, prefix: true

      attr_accessor :id, :state_machine, :from, :to, :callback, :confirm
      attr_writer :icon, :color

      class << self
        def to_proc = -> { new(**_1) }
      end

      def icon
        @icon&.to_sym || :location_arrow
      end

      def color
        @color&.to_sym || :primary
      end

      def action = :"after_#{name}_event"

      def suffixed_name = "#{name}_#{state_machine_name}"

      def i18n_scope = :events

      def human
        translate(i18n_key, default: name.humanize)
      end

      def to_str = <<~RUBY
        event :#{name}, after_commit: :#{action} do
          transitions from: #{Array(from).map(&:to_sym)}, to: :#{to}
        end
      RUBY

      private

      memoize def trigger = Triggers::Trigger.new(id:, entity:, action:, callback:)

      def spec_interpolations = super.merge(name:, from: Array(from).to_sentence, to:)
    end
  end
end
