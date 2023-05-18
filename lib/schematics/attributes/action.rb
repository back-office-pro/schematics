# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Action < String
      def format(value)
        return unless value

        translate(value.to_sym, default: nil, scope: [:activerecord, :enums, entity.name, name]) ||
          translate(:events, scope: 'activerecord')
            .values
            .reduce(&:merge)
            .fetch(value.to_sym, value.humanize)
      end

      def icon = :hand_rock
    end
  end
end
