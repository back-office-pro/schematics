# frozen_string_literal: true

module Schematics
  module Button
    module LicenseComparison
      class Component < ApplicationComponent
        def title = t('.text')

        def icon = :lock_open

        def target = '#license-comparison-modal'
      end
    end
  end
end
