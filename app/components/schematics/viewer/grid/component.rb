# frozen_string_literal: true

module Schematics
  module Viewer
    module Grid
      class Component < Viewer::Component
        def carousel(resource)
          entity.attachment_attributes.map do |attribute|
            resource.instance_eval(attribute.name)
          end
        end
      end
    end
  end
end
