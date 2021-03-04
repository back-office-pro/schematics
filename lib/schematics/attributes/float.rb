require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/fillable'
require 'schematics/behaviours/rangeable'
require 'active_support'
require 'active_support/core_ext'
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

      def validators
        super.merge(numericality: { allow_nil: !required? })
      end

      def unit
        @options[:unit]
      end

      def format(value)
        return if value.nil?
        return number_to_human_size(value) if unit == 'bytes'
        [value, unit].compact.join(' ')
      end

      def icon
        :sort_numeric_up
      end
    end
  end
end
