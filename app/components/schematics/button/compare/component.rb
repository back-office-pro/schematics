# frozen_string_literal: true

module Schematics
  module Button
    module Compare
      class Component < ApplicationComponent
        def render?
          can?(:create, mod::Comparison)
        end
      end
    end
  end
end
