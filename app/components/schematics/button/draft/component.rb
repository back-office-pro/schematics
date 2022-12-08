# frozen_string_literal: true

module Schematics
  module Button
    module Draft
      class Component < ApplicationComponent
        delegate :icon, to: 'mod::Draft.entity'
      end
    end
  end
end
