# frozen_string_literal: true

module Schematics
  module VersionsComparison
    class Component < ApplicationComponent
      option :version
      delegate :item, :entity, to: :version
      delegate :icon, to: :entity

      memoize def previous_item
        version.reify(dup: true)
      end
    end
  end
end
