# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        DENYLIST = %i[Association Attribute Month StateMachineEvent Week Year].freeze
        delegate :default_actions, :actions, :icon, to: '@builder.object'
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def actions_collection
          default_actions.map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }
        end

        def attribute_constants_collection
          (Attributes.constants - DENYLIST).map(&Attributes.method(:const_get))
        end

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
      end
    end
  end
end
