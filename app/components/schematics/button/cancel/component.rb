# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        def initialize(path:)
          super
          @path = path
        end
      end
    end
  end
end
