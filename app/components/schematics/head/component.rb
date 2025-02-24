# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      delegate :theme_color, :company_name, to: 'current_module::Configuration'
      use_helpers :title
    end
  end
end
