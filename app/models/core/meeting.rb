# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Meeting < Schematics::ApplicationRecord
  scope :today, ::Core::Meetings::TodayQuery
end
