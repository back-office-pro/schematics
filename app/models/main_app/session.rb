# frozen_string_literal: true

module MainApp
  module Session
    extend ActiveSupport::Concern

    ONLINE_DELAY = 15.minutes.freeze

    prepended do
      scope :online, -> { where(updated_at: ONLINE_DELAY.ago..) }
    end
  end
end
