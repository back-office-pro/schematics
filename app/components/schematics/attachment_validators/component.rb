# frozen_string_literal: true

module Schematics
  module AttachmentValidators
    class Component < ApplicationComponent
      option :validators

      def render?
        validators.any?
      end
    end
  end
end
