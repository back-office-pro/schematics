# frozen_string_literal: true

module Schematics
  module Button
    module Stale
      class Component < ApplicationComponent
        delegate :version_path, to: 'Schematics::Engine.routes.url_helpers'

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          @resource.errors.of_kind?(:base, :stale) && last_version
        end

        def last_version
          @resource.versions.last
        end
      end
    end
  end
end
