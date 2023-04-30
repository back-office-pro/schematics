# frozen_string_literal: true

class Meeting < Schematics::ApplicationRecord
  scope :today, ::Core::Meeting::TodayQuery
end
