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

        def icons
          # rubocop:disable Naming/VariableNumber
          %i[
            user_tie
            box
            xmark
            ban
            people_carry
            users
            inbox
            file
            gear
            user_lock
            key
            cloud_arrow_up
            id_badge
            chart_line
            stopwatch_20
            magnifying_glass
            scale_balanced
            floppy_disk
            user_shield
          ]
          # rubocop:enable Naming/VariableNumber
        end

        private

        def first_tab?
          @entity_counter == 1
        end
      end
    end
  end
end
