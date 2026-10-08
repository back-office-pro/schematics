# frozen_string_literal: true

module Schematics
  module Viewer
    module ActionButtonGroup
      class Component < ApplicationComponent
        delegate :deleted?, to: :resource
        option :resource
      end
    end
  end
end
