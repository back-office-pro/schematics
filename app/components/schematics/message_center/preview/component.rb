# frozen_string_literal: true

module Schematics
  module MessageCenter
    module Preview
      class Component < ApplicationComponent
        def initialize(message:)
          super
          @message = message
        end

        def css_class
          'font-weight-bold' if @message.unread?
        end

        def href
          message_path(@message)
        end
      end
    end
  end
end
