# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      ASSETS_DIRECTORY = Engine.root.join('app', 'assets', 'stylesheets').freeze
      ASSETS_PATH = %r{#{ASSETS_DIRECTORY}/(.*)\.\w+}

      delegate :theme_color, :company_name, to: ::Configuration
      use_helpers :title

      def asset_paths = Dir
        .glob(ASSETS_DIRECTORY.join('**', '*.css'))
        .map { _1[ASSETS_PATH, 1] }
        .excluding('schematics/application')
    end
  end
end
