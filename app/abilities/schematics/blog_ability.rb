# frozen_string_literal: true

module Schematics
  class BlogAbility < ApplicationAbility
    def initialize
      super
      can :read, ::BlogPost, state: :published
    end
  end
end
