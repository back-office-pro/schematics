# frozen_string_literal: true

class MessageReply < Message
  class << self
    delegate :entity, to: Message

    def from(parent)
      Message.new(
        subject: parent.subject.dup.prepend('RE: '),
        recipients: parent.recipients,
        content: <<~HTML
          <blockquote>#{parent.content}</blockquote>
          <br />
        HTML
      )
    end
  end
end
