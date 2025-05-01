# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module AttachmentValidator
    class Component < ApplicationComponent
      with_collection_parameter :validator

      def initialize(validator:)
        super
        @validator = validator
      end

      def css_classes = class_names('text-danger': antivirus_missing?)

      def title
        return t('.antivirus_missing') if antivirus_missing?

        @validator
      end

      def icon
        return :triangle_exclamation if antivirus_missing?

        :info_circle
      end

      private

      def antivirus?
        @validator == Validators.human_attribute_name('antivirus')
      end

      memoize def antivirus_missing?
        antivirus? && !Clamby::Command.new.run(Clamby::Command.scan_executable, '--ping 0')
      end
    end
  end
end
