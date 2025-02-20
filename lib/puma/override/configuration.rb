# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Puma
  module Override
    module Configuration
      # :reek:UtilityFunction
      def config_files = [Schematics::Engine.root.join('config', 'puma.rb').to_s]
    end
  end
end
