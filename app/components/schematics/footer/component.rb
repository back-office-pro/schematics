# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :setting, to: :helpers
    end
  end
end
