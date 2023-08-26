# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Button
      module Remove
        class Component < ApplicationComponent
          delegate :name, to: :field, private: true
          option :field

          def wrapper = ".nested-association-#{name}"

          def title = t('.title')
        end
      end
    end
  end
end
