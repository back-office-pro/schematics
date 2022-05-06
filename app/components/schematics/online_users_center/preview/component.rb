# frozen_string_literal: true

module Schematics
  module OnlineUsersCenter
    module Preview
      class Component < ApplicationComponent
        delegate :user, :updated_at, to: :@session

        def initialize(session:)
          super
          @session = session
        end

        def href
          user_path(user)
        end
      end
    end
  end
end
