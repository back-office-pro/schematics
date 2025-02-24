# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class FeatureFlagAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :manage, mod::Message unless mod::Configuration.messages_feature_flag
      cannot :manage, mod::Comment unless mod::Configuration.comments_feature_flag
      cannot :manage, mod::Meeting unless mod::Configuration.meetings_feature_flag
      cannot :manage, mod::Task unless mod::Configuration.tasks_feature_flag
    end
  end
end
