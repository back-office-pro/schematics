# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Code < Text
      include Behaviours::Unnormalizable

      delegate :language, to: :options

      def available_options = super.push(Options::Language)

      def icon = :code
    end
  end
end
