# frozen_string_literal: true

module Schematics
  module Input
    module Password
      class Component < ApplicationComponent
        def initialize(form:, name: :password, icon: :key, **options)
          super
          @form = form
          @name = name
          @icon = icon
          @options = options
        end
      end
    end
  end
end
