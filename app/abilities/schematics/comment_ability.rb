# frozen_string_literal: true

module Schematics
  class CommentAbility < ApplicationAbility
    def initialize(user)
      super
      cannot %i[import duplicate update destroy archive], Core::Comment
      can %i[update destroy archive], Core::Comment, author: user
    end
  end
end
