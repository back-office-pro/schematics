# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[show update duplicate destroy archive import], ::Message
      can %i[show update destroy archive], ::Message, author: user
      can :show, ::Message, recipient: user
    end
  end
end
