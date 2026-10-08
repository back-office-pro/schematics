# frozen_string_literal: true

module Schematics
  class EmailTemplateAbility < ApplicationAbility
    def initialize
      super
      cannot :duplicate, ::EmailTemplate
    end
  end
end
