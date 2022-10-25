# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Trigger
      class Component < ApplicationComponent
        renders_one_form :builder
        option :builder

        def collection = Schematics::Trigger::ACTIONS.map do |action|
          [t(action, scope: %i[activerecord attributes permission actions]), action]
        end

        def icon = :atom

        def title = t('.title')

        def wrapper = :input_group
      end
    end
  end
end
