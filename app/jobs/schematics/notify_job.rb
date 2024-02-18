# frozen_string_literal: true

module Schematics
  class NotifyJob < ApplicationJob
    queue_as :notifications

    def perform(item, event, user)
      Version.where(item:, event:, user:).first_or_create!
    end
  end
end
