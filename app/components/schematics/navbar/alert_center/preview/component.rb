# frozen_string_literal: true

module Schematics
  module Navbar
    module AlertCenter
      module Preview
        class Component < ApplicationComponent
          delegate :record, to: :@alert
          with_collection_parameter :alert

          def initialize(alert:)
            super
            @alert = alert
          end

          def href = polymorphic_path(record)
        end
      end
    end
  end
end
