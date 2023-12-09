# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[read comment update duplicate destroy archive import], ::Message
      can %i[read reply update destroy archive], ::Message, author: user
      can %i[read reply], ::Message, recipients: { id: [user.id] }
      cannot %i[reply update destroy], ::Message do |parent|
        ::Message.exists?(parent:)
      end
    end
  end
end
