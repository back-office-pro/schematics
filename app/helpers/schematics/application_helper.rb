# frozen_string_literal: true

module Schematics
  module ApplicationHelper
    include Pagy::Frontend

    def current_draft
      @current_draft ||= current_user
                         .drafts
                         .find_by(name: "new_#{entity.table_name}")
    end

    def edit_polymorphic_path(resource)
      case resource
      when Singleton # rubocop:disable Lint/ConstantResolution
        super(resource.class)
      else
        super
      end
    end

    # :reek:UnusedParameters
    def fa_icon(icon, class: nil, size: nil, animation: nil, **kwargs)
      tag.i(
        class: ['solid', icon.to_s.dasherize, size, animation]
          .compact
          .map { "fa-#{_1}" }
          .push(binding.local_variable_get(:class)),
        **kwargs
      )
    end

    def i18n_javascript = t('javascript')
      .deep_transform_keys { _1.to_s.camelize(:lower) }
      .to_json
      .html_safe # rubocop:disable Rails/OutputSafety

    def maps_api_key_javascript = settings(:google_cloud_api_key)
      .to_json
      .html_safe # rubocop:disable Rails/OutputSafety

    def preferences(key, default = nil)
      current_user.preferences.fetch(key.to_s, default)
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
            .select(&only)
            .map do |association|
              resource
                .public_send(association.name)
                .then_tap do |query|
                  unless association.is_a?(Associations::HasAndBelongsToMany)
                    query.preload(association.entity.includes)
                  end
                end
                .accessible_by(current_ability)
                .order(created_at: :desc)
            end
        ).compact_blank
    end

    def rollbar_client_key_javascript = Schematics::Engine
      .credentials
      .rollbar[:client_key]
      .to_json
      .html_safe # rubocop:disable Rails/OutputSafety

    def settings(key)
      Rails.cache.fetch("settings/#{key}") do
        ::Setting
          .with_attached_company_logo
          .instance
          .public_send(key)
      end
    end

    def theme_color_darken = settings(:theme_color)
      .paint
      .darken(5)
      .to_s

    def theme_color_rgb = settings(:theme_color)
      .paint
      .to_rgb
      .scan(/\d+/)
      .join(', ')
  end
end
