# frozen_string_literal: true

module Schematics
  module AttachmentValidator
    class Component < ApplicationComponent
      with_collection_parameter :validator

      def initialize(validator:)
        super
        @validator = validator
      end

      def icon = :info_circle

      memoize def antivirus_missing?
        antivirus? &&
          ENV['CLAMAV_HOST'].blank? &&
          !Clamby::Command.new.run(Clamby::Command.scan_executable, '--ping 0')
      end

      private

      def antivirus?
        @validator == Validators.human_attribute_name('antivirus')
      end
    end
  end
end
