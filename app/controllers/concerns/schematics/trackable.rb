# frozen_string_literal: true

module Schematics
  module Trackable
    extend ActiveSupport::Concern

    included do
      before_action :update_last_seen_at!, unless: -> { request.format.json? }
    end

    def update_last_seen_at!
      current_user&.update!(last_seen_at: ::Time.current)
    end
  end
end
