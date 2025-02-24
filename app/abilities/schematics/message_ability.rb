# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[read comment update duplicate destroy archive import], mod::Message
      can %i[read reply update destroy archive], mod::Message, author: user
      can %i[read reply], mod::Message, recipients: { id: [user.id] }
      cannot %i[reply update destroy], mod::Message do |parent|
        mod::Message.exists?(parent:)
      end
    end
  end
end
