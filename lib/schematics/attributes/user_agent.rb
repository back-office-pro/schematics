# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'browser'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class UserAgent < String
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def icon = :computer

      def format(value)
        return unless value

        browser = Browser.new(value)
        [browser.name, browser.version, browser.platform.name].join(' ')
      end
    end
  end
end
