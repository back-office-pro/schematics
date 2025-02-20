# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Migrator
      class Component < ApplicationComponent
        delegate :migrator_build_commands, :migrator_clean_commands, to: :resource
        option :resource

        def title = t('.title')

        def icon = :arrows_rotate

        def render? = migrator_build_commands
          .concat(migrator_clean_commands)
          .any?
      end
    end
  end
end
