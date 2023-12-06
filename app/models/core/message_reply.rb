# frozen_string_literal: true

class MessageReply < Message
  class << self
    delegate :entity, to: Message

    def from(message)
      Message.new(
        subject: message.subject.dup.prepend('RE: '),
        recipients: message.recipients,
        content: <<~HTML
          <blockquote>#{message.content}</blockquote>
          <br />
        HTML
      )
    end
  end
end
