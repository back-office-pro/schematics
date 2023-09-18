# frozen_string_literal: true

module Schematics
  module EmptyResource
    class Component < ApplicationComponent
      option :suggestions, default: -> { [] }
    end
  end
end
