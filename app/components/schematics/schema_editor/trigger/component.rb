# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def collection = Schematics::Trigger::ACTIONS.map do |action|
          [t(action, scope: %i[activerecord attributes permission actions]), action]
        end

        def icon = :atom

        def title = t('.title')
      end
    end
  end
end
