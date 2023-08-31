# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Uuid < Attribute
      include Behaviours::Renderable

      def default = SecureRandom.uuid

      def icon = :id_card

      def format(value)
        return unless value
        return value unless entity.model_class

        "#{entity.model_class.model_name.human} ##{value.split('-').first}"
      end
    end
  end
end
