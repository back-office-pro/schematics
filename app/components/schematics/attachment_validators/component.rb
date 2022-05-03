# frozen_string_literal: true

module Schematics
  module AttachmentValidators
    class Component < ApplicationComponent
      def initialize(validators:)
        super
        @validators = validators
      end

      def render?
        @validators.any?
      end
    end
  end
end
