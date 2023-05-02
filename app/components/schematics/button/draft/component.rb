# frozen_string_literal: true

module Schematics
  module Button
    module Draft
      class Component < ApplicationComponent
        delegate :icon, to: 'Core::Draft.entity'
      end
    end
  end
end
