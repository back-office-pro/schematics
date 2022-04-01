# frozen_string_literal: true

module Schematics
  module Button
    module Cancel
      class Component < ApplicationComponent
        def initialize(path: nil)
          super
          @path = path
        end

        def data
          return if @path

          { 'bs-dismiss': 'modal' }
        end
      end
    end
  end
end
