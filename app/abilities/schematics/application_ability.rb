# frozen_string_literal: true

module Schematics
  class ApplicationAbility
    include CanCan::Ability

    def initialize(*)
      alias_action :duplicate, :import, to: :create
      alias_action :restore, to: :archive
      alias_action :delete, to: :destroy
    end
  end
end
