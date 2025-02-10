# frozen_string_literal: true

module Core
  module Meeting
    extend ActiveSupport::Concern

    prepended do
      scope :today, Meetings::TodayQuery
    end
  end
end
