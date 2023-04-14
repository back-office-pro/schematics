# frozen_string_literal: true

module Application
  module Message
    extend ActiveSupport::Concern

    prepended do
      scope :unread, UnreadQuery
    end

    def read?(user)
      versions.exists?(event: 'show', user:)
    end

    def mentions = content
      .body
      .attachables
      .grep(::User)
      .uniq
  end
end
