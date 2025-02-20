# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Color < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      REGEX = /\A#(?:\h{3}){1,2}\z/

      def default = '#000000'

      def icon = :palette

      def validators = super.merge(
        allow_blank:,
        format: { with: REGEX, message: :color }
      )
    end
  end
end
