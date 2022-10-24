# frozen_string_literal: true

module Schematics
  module Navbar
    module OnlineUsersCenter
      module Preview
        class Component < ApplicationComponent
          delegate :user, :updated_at, to: :session
          option :session

          def href = user_path(user)
        end
      end
    end
  end
end
