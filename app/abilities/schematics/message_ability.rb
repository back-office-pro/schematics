# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[read update duplicate destroy archive import], Core::Message
      can %i[read update destroy archive], Core::Message, author: user
      can :read, Core::Message, recipients: { id: [user.id] }
    end
  end
end
