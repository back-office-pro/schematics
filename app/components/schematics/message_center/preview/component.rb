module Schematics
  module MessageCenter
    module Preview
      class Component < ::ViewComponent::Base
        def initialize(message:)
          @message = message
        end
      end
    end
  end
end
