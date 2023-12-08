# frozen_string_literal: true

get 'messages/:message_id/replies/new',
    to: 'message_replies#new',
    model_name: 'Message',
    as: :new_message_reply
post 'messages/:message_id/replies',
     to: 'message_replies#create',
     model_name: 'Message',
     as: :message_replies
