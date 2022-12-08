# frozen_string_literal: true

module Schematics
  class MessageAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[show update duplicate destroy archive import], mod::Message
      can %i[show update destroy archive], mod::Message, author: user
      can :show, mod::Message, recipient: user
    end
  end
end
