# frozen_string_literal: true

module Schematics
  class CommentAbility < ApplicationAbility
    def initialize(user, mod)
      super
      cannot %i[import duplicate update destroy archive], mod::Comment
      can %i[update destroy archive], mod::Comment, author: user
    end
  end
end
