# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module MessageCenter
      module Preview
        class Component < ApplicationComponent
          delegate :author, :subject, :created_at, :read?, to: :@message
          with_collection_parameter :message

          def initialize(message:)
            super
            @message = message
          end

          def css_class
            'fw-bold' unless read?(current_user)
          end

          def href = resource_path(@message)
        end
      end
    end
  end
end
