# frozen_string_literal: true

module Core
  module Meeting
    extend ActiveSupport::Concern

    prepended do
      scope :today, TodayQuery
    end
  end
end
