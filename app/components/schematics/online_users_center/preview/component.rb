# frozen_string_literal: true

module Schematics
  module OnlineUsersCenter
    module Preview
      class Component < ApplicationComponent
        def initialize(user:)
          super
          @user = user
        end

        def href
          user_path(@user)
        end
      end
    end
  end
end
