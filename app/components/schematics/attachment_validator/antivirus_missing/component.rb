# frozen_string_literal: true

module Schematics
  module AttachmentValidator
    module AntivirusMissing
      class Component < ApplicationComponent
        def title = t('.title')

        def icon = :triangle_exclamation
      end
    end
  end
end
