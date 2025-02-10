# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      delegate :theme_color, :company_name, to: '::Configuration'
      use_helpers :title
    end
  end
end
