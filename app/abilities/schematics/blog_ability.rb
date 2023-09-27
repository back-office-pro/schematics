# frozen_string_literal: true

module Schematics
  class BlogAbility < ApplicationAbility
    def initialize
      super
      can :read, ::BlogPost, state: ::BlogPost::STATE_STATE_PUBLISHED
    end
  end
end
