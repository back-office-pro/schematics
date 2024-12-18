# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Uuid < Attribute
      include Behaviours::Migratable
      include Behaviours::Renderable

      def default = SecureRandom.uuid

      def icon = :id_card

      def format(value)
        return unless value

        [entity.model_class&.model_name&.human, value]
          .compact
          .join(' ')
      end
    end
  end
end
