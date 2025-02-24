# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailTemplateAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :duplicate, mod::EmailTemplate
    end
  end
end
