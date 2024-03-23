# frozen_string_literal: true

module SolidQueue
  module Override
    module Configuration
      def config_from(*)
        super(Schematics::Engine.root.join('config', 'solid_queue.yml'))
      end
    end
  end
end
