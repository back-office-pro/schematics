# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    # :reek:UnusedParameters
    # :reek:LongParameterList
    def fa_icon(icon, style: 'solid', class: nil, size: nil, animation: nil, **kwargs) # rubocop:disable Metrics/ParameterLists
      tag.i(
        class: [style, icon.to_s.dasherize, size, animation]
          .compact
          .map { "fa-#{_1}" }
          .push(binding.local_variable_get(:class)),
        **kwargs
      )
    end

    def preferences(key, default = nil)
      current_user.preferences.fetch(key.to_s, default)
    end

    def config(key)
      Rails.cache.fetch("#{current_tenant.name}:configuration/#{key}") do
        current_tenant.mod::Configuration
          .with_attached_company_logo
          .instance
          .public_send(key)
      end
    end
  end
end
