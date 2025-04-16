# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Message < Schematics::ApplicationRecord
  scope :unread, ::Core::Messages::UnreadQuery
  scope :read, ::Core::Messages::ReadQuery

  def new_reply = self
    .class
    .new(
      subject: subject.dup.prepend('RE: '),
      recipients:,
      content: <<~HTML
        <blockquote>#{content}</blockquote>
        <br />
      HTML
    )

  def read?(user)
    paper_trail_versions.exists?(event: 'show', user:)
  end

  def rich_text_mentions = []
end
