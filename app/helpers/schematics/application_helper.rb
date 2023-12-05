# frozen_string_literal: true

module Schematics
  module ApplicationHelper
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

    def component(path, method_or_collection = :new, **params, &)
      case method_or_collection
      when Enumerable
        render Schematics
          .const_get(path.to_s.camelize)
          .const_get(:Component)
          .with_collection(method_or_collection, **params), &
      else
        render Schematics
          .const_get(path.to_s.camelize)
          .const_get(:Component)
          .public_send(method_or_collection, **params), &
      end
    end
  end
end
