# frozen_string_literal: true

module Schematics
  module Head
    class Component < ApplicationComponent
      delegate :theme_color, :company_name, to: '::Configuration'
      delegate :title, to: :helpers
    end
  end
end
