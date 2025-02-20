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
    end
  end
end
