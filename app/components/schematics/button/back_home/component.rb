# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module BackHome
      class Component < ApplicationComponent
        def icon = :house

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split me-1]
      end
    end
  end
end
