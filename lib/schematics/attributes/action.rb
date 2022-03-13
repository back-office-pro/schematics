# frozen_string_literal: true

module Schematics
  module Attributes
    class Action < String
      def format(value)
        return unless value

        scope = [:activerecord, :attributes, @entity.name, name.pluralize]
        translate(value.to_sym, default: nil, scope:) ||
          translate('activerecord.events')
            .values
            .reduce(:merge)
            .fetch(value.to_sym, value.humanize)
      end

      def icon
        :hand_rock
      end
    end
  end
end
