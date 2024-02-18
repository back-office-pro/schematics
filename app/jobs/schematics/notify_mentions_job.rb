# frozen_string_literal: true

module Schematics
  class NotifyMentionsJob < ApplicationJob
    queue_as :notifications

    def perform(resource)
      PaperTrail.request(enabled: false) do
        resource.mentions.each do |user|
          Version.create!(event: 'mention', item: resource, user:)
        end
      end
    end
  end
end
