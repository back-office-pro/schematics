# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        delegate :default_actions, :actions, :icon, :descriptor, to: 'builder.object'
        delegate :allowed_field_names, to: :descriptor
        delegate :index, to: :builder
        renders_one_form :builder
        option :builder

        def actions_collection = default_actions
          .map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }
          .sort

        def icon = builder
          .object
          .icon
          .to_s
          .dasherize
      end
    end
  end
end
