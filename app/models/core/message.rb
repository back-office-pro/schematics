# frozen_string_literal: true

module Core
  class Message < Schematics::ApplicationRecord
    scope :unread, Messages::UnreadQuery

    def read?(user)
      versions.exists?(event: 'show', user:)
    end

    def mentions = content
      .body
      .attachables
      .grep(User)
      .uniq
  end
end
