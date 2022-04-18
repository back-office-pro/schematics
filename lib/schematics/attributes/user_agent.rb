# frozen_string_literal: true

require 'browser'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class UserAgent < String
      def format(value)
        return unless value

        browser = Browser.new(value)
        [browser.name, browser.version, browser.platform.name].join(' ')
      end

      def icon
        :computer
      end
    end
  end
end
