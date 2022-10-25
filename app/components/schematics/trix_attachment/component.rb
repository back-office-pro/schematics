# frozen_string_literal: true

module Schematics
  module TrixAttachment
    class Component < ApplicationComponent
      delegate :class, to: :resource, prefix: :model, private: true
      delegate :entity, to: :model_class, private: true
      delegate :icon, to: :entity
      option :resource
    end
  end
end
