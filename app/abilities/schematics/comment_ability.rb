# frozen_string_literal: true

module Schematics
  class CommentAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[import duplicate update destroy archive], ::Comment
      can %i[update destroy archive], ::Comment, author: user
    end
  end
end
