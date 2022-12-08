# frozen_string_literal: true

module Schematics
  class FeatureFlagAbility < ApplicationAbility
    delegate :messages_feature_flag,
             :comments_feature_flag,
             :tasks_feature_flag,
             :meetings_feature_flag,
             to: :config,
             private: true

    def initialize(mod)
      super
      @mod = mod
      cannot :manage, mod::Message unless messages_feature_flag
      cannot :manage, mod::Comment unless comments_feature_flag
      cannot :manage, mod::Meeting unless meetings_feature_flag
      cannot :manage, mod::Task unless tasks_feature_flag
    end

    private

    def config
      @config ||= @mod::Configuration.instance
    end
  end
end
