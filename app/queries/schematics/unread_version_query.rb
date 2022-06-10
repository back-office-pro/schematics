# frozen_string_literal: true

module Schematics
  class UnreadVersionQuery < ApplicationQuery
    def call(read_notifications_at)
      where(created_at: read_notifications_at...)
    end

    protected

    def model_class = Version
  end
end
