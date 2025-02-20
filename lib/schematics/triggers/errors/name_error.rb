# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Triggers
    module Errors
      class NameError < StandardError
        def to_s = translate('errors.triggers.name', name:)
      end
    end
  end
end
