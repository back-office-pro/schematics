# frozen_string_literal: true

module Core
  class Meeting < Schematics::ApplicationRecord
    scope :today, Meetings::TodayQuery
  end
end
