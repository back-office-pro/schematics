# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Action < String
      def format(value)
        return unless value

        translate(
          value.to_sym,
          default: nil,
          scope: [:activerecord, :attributes, entity.name, name.pluralize]
        ) || translate(value.to_sym, default: value.humanize, scope: %i[activerecord events])
      end

      def icon = :hand_rock
    end
  end
end
