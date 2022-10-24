# frozen_string_literal: true

module Schematics
  module Navbar
    module MessageCenter
      module Preview
        class Component < ApplicationComponent
          delegate :author, :subject, :created_at, :unread?, to: :message
          option :message

          def css_class
            'fw-bold' if unread?
          end

          def href = message_path(message)
        end
      end
    end
  end
end
