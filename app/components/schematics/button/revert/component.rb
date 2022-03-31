# frozen_string_literal: true

module Schematics
  module Button
    module Revert
      class Component < ApplicationComponent
        delegate :revert_version_path, to: 'Schematics::Engine.routes.url_helpers'

        def initialize(version:)
          super
          @version = version
        end

        def render?
          can?(:revert, @version)
        end
      end
    end
  end
end
