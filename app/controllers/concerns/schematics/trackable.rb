# frozen_string_literal: true

module Schematics
  module Trackable
    extend ActiveSupport::Concern

    included do
      before_action :track!, unless: -> { request.format.json? }
    end

    def track!
      current_session.update!(updated_at: ::Time.current)
    end
  end
end
