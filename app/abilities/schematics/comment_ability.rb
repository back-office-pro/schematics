# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class CommentAbility < ApplicationAbility
    def initialize(user, mod)
      super
      can :comment, :all
      cannot %i[import comment duplicate update destroy archive], mod::Comment
      can %i[update destroy archive], mod::Comment, author: user
    end
  end
end
