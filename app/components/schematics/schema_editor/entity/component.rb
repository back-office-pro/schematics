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

        def icons
          YAML
            .load_file(Schematics::Engine.root.join('lib', 'font_awesome_icons.yml'))
            .map do |text|
              {
                innerHTML: fa_icon(text, class: 'fa-fw', size: '2x'),
                selected: text == icon.to_s,
                text:
              }
            end
        end

        def wrapper = :input_group
      end
    end
  end
end
