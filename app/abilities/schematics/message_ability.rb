# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[read update duplicate destroy archive import], ::Message
      can %i[read update destroy archive], ::Message, author: user
      can :read, ::Message, users: { id: [user.id] }
    end
  end
end
