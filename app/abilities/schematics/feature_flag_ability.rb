# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class FeatureFlagAbility < ApplicationAbility
    delegate :messages_feature_flag,
             :comments_feature_flag,
             :tasks_feature_flag,
             :meetings_feature_flag,
             to: '::Configuration',
             private: true

    def initialize
      super
      cannot :manage, ::Message unless messages_feature_flag
      cannot :manage, ::Comment unless comments_feature_flag
      cannot :manage, ::Meeting unless meetings_feature_flag
      cannot :manage, ::Task unless tasks_feature_flag
    end
  end
end
