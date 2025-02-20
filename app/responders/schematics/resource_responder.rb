# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceResponder
    include InteractorResponder

    delegate :errors, to: 'resource.resource', private: true
    delegate :action_name, to: :controller, private: true

    protected

    def message = super
      .dup
      .prepend("schematics.resources.#{action_name}")
  end
end
