# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Entity
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer

        delegate :table_name, :attributes, :virtuals, :triggers, :options, to: :@entity
        with_collection_parameter :entity

        def initialize(entity:, entity_counter:, form:)
          super
          @entity = entity
          @entity_counter = entity_counter
          @form = form
        end

        def actions = @entity
          .default_actions
          .map { [t(_1, scope: %i[activerecord attributes permission actions]), _1] }

        def css_classes
          %w[show active] if first_tab?
        end

        def icons = YAML
          .load_file(Schematics::Engine.root.join('lib', 'font_awesome_icons.yml'))
          .map { |text| { innerHTML: fa_icon(text, class: 'fa-fw', size: '2x'), text: } }

        private

        def first_tab?
          @entity_counter == 1
        end
      end
    end
  end
end
