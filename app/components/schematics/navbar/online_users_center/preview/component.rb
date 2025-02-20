# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module OnlineUsersCenter
      module Preview
        class Component < ApplicationComponent
          delegate :user, :updated_at, to: :@session
          with_collection_parameter :session

          def initialize(session:)
            super
            @session = session
          end

          def href = resource_path(user)
        end
      end
    end
  end
end
