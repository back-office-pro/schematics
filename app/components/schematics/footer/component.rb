# frozen_string_literal: true

module Schematics
  module Footer
    class Component < ApplicationComponent
      delegate :settings, to: :helpers
    end
  end
end
