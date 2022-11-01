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
      Rails.cache.fetch("configuration/#{key}") do
        ::Configuration
          .with_attached_company_logo
          .instance
          .public_send(key)
      end
    end

    def resource_associations(resource:, only: nil)
      resource
        .class
        .entity
        .attachments_attributes
        .map do |attribute|
          resource
            .public_send(attribute.name)
            .preload(:blob)
            .order(created_at: :desc)
        end
        .concat(
          resource
            .class
            .entity
            .has_many_and_through_and_belongs_to_many_associations
            .reject(&:existing?)
            .select(&only)
            .map do |association|
              resource
                .public_send(association.name)
                .preload(association.includes)
                .accessible_by(current_ability)
                .order(created_at: :desc)
            end
        ).compact_blank
    end
  end
end
