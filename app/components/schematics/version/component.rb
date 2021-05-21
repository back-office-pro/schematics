# frozen_string_literal: true

module Schematics
  module Version
    class Component < ApplicationComponent
      delegate :version_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :user, :item, :created_at, :icon, to: :@version

      def initialize(version:)
        super
        @version = version
      end
    end
  end
end
