# frozen_string_literal: true

module Schematics
  module VersionPreview
    class Component < ApplicationComponent
      delegate :version_path, to: 'Schematics::Engine.routes.url_helpers'
      delegate :user, :item, :created_at, :icon, :object, to: :version
      option :version

      def action
        return unless href

        %w[click->application#visit]
      end

      def href
        return unless item
        return unless object

        version_path(version)
      end
    end
  end
end
