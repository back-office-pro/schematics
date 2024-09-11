# frozen_string_literal: true

module SolidQueue
  module Override
    module Configuration
      def default_options = super.merge(
        recurring_schedule_file: Schematics::Engine.root.join('config', 'recurring.yml')
      )
    end
  end
end
