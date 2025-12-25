# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    COMPONENTS_DIRECTORY = Rails.root.join('app/components/schematics').freeze
    ASSETS_DIRECTORY = Rails.root.join('app/assets/stylesheets').freeze
    COMPONENTS_PATH = %r{#{COMPONENTS_DIRECTORY}/(.*)/component\.rb}
    ASSETS_PATH = %r{#{ASSETS_DIRECTORY}/(.*)\.\w+}

    # :reek:UnusedParameters
    # :reek:LongParameterList
    def fa_icon(icon, style: 'solid', class: nil, size: nil, animation: nil, **) # rubocop:disable Metrics/ParameterLists
      tag.i(
        class: [style, icon.to_s.dasherize, size, animation]
          .compact
          .map { "fa-#{_1}" }
          .push(binding.local_variable_get(:class)),
        **
      )
    end

    def stylesheet_link_tags = Dir
      .glob(ASSETS_DIRECTORY.join('**', '*.css'))
      .map { _1[ASSETS_PATH, 1] }
      .each_with_object(media: 'all', 'data-turbo-track': 'reload')
      .map(&method(:stylesheet_link_tag))
      .join

    Dir
      .glob(COMPONENTS_DIRECTORY.join('**', 'component.rb'))
      .map { _1[COMPONENTS_PATH, 1] }
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
