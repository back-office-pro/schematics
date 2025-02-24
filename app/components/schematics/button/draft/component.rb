# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Draft
      class Component < ApplicationComponent
        delegate :icon, to: 'current_module::Draft.entity'

        def title = t('.text')
      end
    end
  end
end
