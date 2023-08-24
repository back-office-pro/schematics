# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Button
      module Remove
        class Component < ApplicationComponent
          option :attribute

          def title = t('.title')
        end
      end
    end
  end
end
