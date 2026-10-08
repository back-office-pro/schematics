# frozen_string_literal: true

module Schematics
  module GoogleMap
    module MissingAPIKey
      class Component < ApplicationComponent
        def icon = :triangle_exclamation

        def title = t('.title')
      end
    end
  end
end
