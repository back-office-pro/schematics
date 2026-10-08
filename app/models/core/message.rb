# frozen_string_literal: true

class ::Message < Schematics::ApplicationRecord
  scope :unread, ::Core::Messages::UnreadQuery

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
