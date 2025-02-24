# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class PDFTemplateAbility < ApplicationAbility
    def initialize(mod)
      super
      cannot :duplicate, mod::PDFTemplate
    end
  end
end
