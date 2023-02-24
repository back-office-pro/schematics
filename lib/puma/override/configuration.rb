# frozen_string_literal: true

module Puma
  module Override
    module Configuration
      def config_files = [Schematics::Engine.root.join('config', 'puma.rb').to_s]
    end
  end
end
