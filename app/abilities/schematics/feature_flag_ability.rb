# frozen_string_literal: true

module Schematics
  class FeatureFlagAbility < ApplicationAbility
    delegate :messages_feature_flag,
             :comments_feature_flag,
             :tasks_feature_flag,
             :meetings_feature_flag,
             :blog_feature_flag,
             to: Core::Configuration,
             private: true

    def initialize
      super
      cannot :manage, Core::Message unless messages_feature_flag
      cannot :manage, Core::Comment unless comments_feature_flag
      cannot :manage, Core::Meeting unless meetings_feature_flag
      cannot :manage, Core::Task unless tasks_feature_flag
      cannot :manage, Core::BlogPost unless blog_feature_flag
    end
  end
end
