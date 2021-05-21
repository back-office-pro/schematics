# frozen_string_literal: true

module Schematics
  module MessageCenter
    module Preview
      class Component < ApplicationComponent
        def initialize(message:)
          super
          @message = message
        end
      end
    end
  end
end
