# frozen_string_literal: true

module Schematics
  module Behaviours
    module Unnormalizable
      def available_options = super.excluding(Options::Normalization)

      def normalization = nil
    end
  end
end
