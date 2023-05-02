# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      delegate :title, to: :helpers
      delegate :theme_color, :company_name, to: Core::Configuration
    end
  end
end
