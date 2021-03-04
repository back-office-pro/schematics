module Schematics
  module MessageCenter
    module Preview
      class Component < ::ViewComponent::Base
        def initialize(message:)
          super
          @message = message
        end
      end
    end
  end
end
