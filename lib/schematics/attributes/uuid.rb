# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Uuid < Attribute
      include Behaviours::Renderable

      def default = SecureRandom.uuid

      def icon = :id_card
    end
  end
end
