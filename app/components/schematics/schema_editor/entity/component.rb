# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        delegate :table_name, :default_actions, :actions, :icon, to: '@builder.object'

        def initialize(builder:)
          super
          @builder = builder
        end

        def collection
          default_actions.map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }
        end

        def fields_css_class = "#{table_name}-fields"

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

        def tab_css_classes
          %w[show active] if @builder.index.try(:zero?)
        end
      end
    end
  end
end
