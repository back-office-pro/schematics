# frozen_string_literal: true

module Schematics
  class FeatureFlagAbility < ApplicationAbility
    delegate :messages_feature_flag,
             :comments_feature_flag,
             :tasks_feature_flag,
             to: :settings

    def initialize
      super
      cannot :manage, ::Message unless messages_feature_flag
      cannot :manage, ::Comment unless comments_feature_flag
      cannot :manage, ::Task unless tasks_feature_flag
    end

    private

    def settings
      @settings ||= ::Setting.instance
    end
  end
end
