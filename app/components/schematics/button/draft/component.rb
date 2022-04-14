# frozen_string_literal: true

module Schematics
  module Button
    module Draft
      class Component < ApplicationComponent
        def icon
          ::Draft.entity.icon
        end
      end
    end
  end
end
