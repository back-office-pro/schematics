# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Address < String
      include Behaviours::Untranslatable

      def icon = :location_dot
    end
  end
end
