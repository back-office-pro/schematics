# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[show update duplicate destroy archive import], ::Message
      can :show, ::Message, recipient: user
      can :show, ::Message, author: user
    end
  end
end
