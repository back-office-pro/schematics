# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module SolidQueue
  module Override
    module Configuration
      def default_options = super.merge(
        config_file: Schematics::Engine.root.join('config', 'queue.yml'),
        recurring_schedule_file: Schematics::Engine.root.join('config', 'recurring.yml')
      )
    end
  end
end
