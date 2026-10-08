# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Secret < Attribute
      include Behaviours::Migratable
      include Behaviours::Renderable
      include Behaviours::Fillable
      include Behaviours::Encryptable
      include Behaviours::Normalizable

      def available_options = super.excluding(Options::Encrypted)

      def database_type = 'string'

      def encrypted? = true

      def default = SecureRandom.base58

      def openai_description = 'An attribute which represents a secret'

      def icon = :user_secret
    end
  end
end
