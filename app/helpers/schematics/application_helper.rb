# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    COMPONENTS_DIRECTORY = Rails.root.join('app/components/schematics').freeze
    COMPONENTS_PATH = %r{#{COMPONENTS_DIRECTORY}/(.*)/component\.rb}

    # :reek:UnusedParameters
    # :reek:LongParameterList
    def fa_icon(icon, style: 'solid', class: nil, size: nil, animation: nil, **) # rubocop:disable Metrics/ParameterLists
      tag.i(
        class: [style, icon.to_s.dasherize, size, animation]
          .compact
          .map { "fa-#{it}" }
          .push(binding.local_variable_get(:class)),
        **
      )
    end

    Dir
      .glob(COMPONENTS_DIRECTORY.join('**', 'component.rb'))
      .map { it[COMPONENTS_PATH, 1] }
      .each do |component|
        method_name = component.tr('/', '_').prepend('__')
        define_method(method_name) do |method_or_collection = :new, **kwargs, &block|
          case method_or_collection
          when Enumerable
            render Schematics
              .const_get(component.camelize)
              .const_get(:Component)
              .with_collection(method_or_collection, **kwargs), &block
          else
            render Schematics
              .const_get(component.camelize)
              .const_get(:Component)
              .public_send(method_or_collection, **kwargs), &block
          end
        end
      end
  end
end
