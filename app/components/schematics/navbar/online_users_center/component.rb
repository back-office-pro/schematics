# frozen_string_literal: true

module Schematics
  module Navbar
    module OnlineUsersCenter
      class Component < ApplicationComponent
        def sessions
          @sessions ||= ::Session
                        .with_user_avatar
                        .active
                        .select('DISTINCT ON (user_id) *')
                        .order(:user_id, updated_at: :desc)
        end
      end
    end
  end
end
