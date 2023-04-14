# frozen_string_literal: true

module Application
  module Meeting
    extend ActiveSupport::Concern

    prepended do
      scope :today, TodayQuery
    end
  end
end
