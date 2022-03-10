# frozen_string_literal: true

module Schematics
  module Trackable
    extend ActiveSupport::Concern

    included do
      before_action :update_last_seen_at!
    end

    def update_last_seen_at!
      return if request.format.json?
      return if stale?(current_user)

      current_user.update!(last_seen_at: ::Time.current)
    end
  end
end
