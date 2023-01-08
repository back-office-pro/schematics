# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module RichText
        class Component < Fields::Component
          def data = { controller: 'mentions' }
        end
      end
    end
  end
end
