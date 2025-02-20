# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    COMPONENTS_DIRECTORY = Engine.root.join('app', 'components', 'schematics').freeze
    ASSETS_DIRECTORY = Engine.root.join('app', 'assets', 'stylesheets').freeze
    COMPONENTS_PATH = %r{#{COMPONENTS_DIRECTORY}/(.*)/component\.rb}
    ASSETS_PATH = %r{#{ASSETS_DIRECTORY}/(.*)\.\w+}

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

    def stylesheet_link_tags = Dir
      .glob(ASSETS_DIRECTORY.join('**', '*.css'))
      .map { it[ASSETS_PATH, 1] }
      .each_with_object(media: 'all', 'data-turbo-track': 'reload')
      .map(&method(:stylesheet_link_tag))
      .join

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
