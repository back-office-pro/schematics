# frozen_string_literal: true

class Message < Schematics::ApplicationRecord
  scope :unread, ::Core::Message::UnreadQuery

  def read?(user)
    versions.exists?(event: 'show', user:)
  end

  def mentions = content
    .body
    .attachables
    .grep(::User)
    .uniq
end
