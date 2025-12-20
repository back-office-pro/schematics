# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Mentionable
    extend ActiveSupport::Concern

    included do
      after_save_commit :notify_mentions
    end

    def rich_text_mentions = self
      .class
      .entity
      .rich_text_attributes
      .map(&:name)
      .map(&method(:public_send))
      .filter_map(&:body)
      .map(&:attachables)
      .flatten
      .grep(::User)
      .uniq

    protected

    def notify_mentions = ::ActiveJob.perform_all_later(
      rich_text_mentions.map { NotifyJob.new(self, 'mention', _1) }
    )
  end
end
