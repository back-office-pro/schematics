# frozen_string_literal: true

require 'resolv'

module Schematics
  module Attributes
    class Inet < Attribute
      include Behaviours::Renderable
      include Behaviours::Fillable

      def validators
        super.merge(
          {
            allow_blank:,
            format: { with: ::Resolv::AddressRegex, message: :ip_address }
          }.compact_blank
        )
      end

      def default
        '::1'
      end

      def icon
        :network_wired
      end
    end
  end
end
