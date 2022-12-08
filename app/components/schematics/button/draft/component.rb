# frozen_string_literal: true

module Schematics
  module Button
    module Draft
      class Component < ApplicationComponent
        delegate :icon, to: 'current_tenant.mod::Draft.entity'
      end
    end
  end
end
