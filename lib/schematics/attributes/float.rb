# frozen_string_literal: true

require 'active_support'
require 'action_view/helpers/number_helper'

module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include ActionView::Helpers::NumberHelper

      delegate :unit, to: :options

      def validators
        super.merge(numericality: { allow_nil: !required? })
      end

      def format(value)
        return unless value
        return number_to_human_size(value) if unit == 'bytes'

        [value, unit].compact.join(' ')
      end

      def icon
        :sort_numeric_up
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
