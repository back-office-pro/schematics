# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Phone < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def default = ::Array
        .new(8) { rand(8) }
        .join
        .prepend('+3306')

      def icon = :phone

      def validators = super.merge(
        phone: { allow_blank: }
      )
    end
  end
end
