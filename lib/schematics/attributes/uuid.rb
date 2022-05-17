# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Uuid < Attribute
      include Behaviours::Renderable

      def unique? = true

      def default = SecureRandom.uuid
    end
  end
end
