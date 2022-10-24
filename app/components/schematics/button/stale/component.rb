# frozen_string_literal: true

module Schematics
  module Button
    module Stale
      class Component < ApplicationComponent
        delegate :version_path, to: 'Schematics::Engine.routes.url_helpers'
        option :resource

        def last_version = resource
          .versions
          .last

        def render?
          resource.errors.of_kind?(:base, :stale) && last_version
        end
      end
    end
  end
end
