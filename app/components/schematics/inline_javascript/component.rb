# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module InlineJavascript
    class Component < ApplicationComponent
      delegate :credentials, to: 'Schematics::Engine', private: true
      delegate :user_notifications_path,
               :preferences_path,
               :emojis_path,
               to: 'Schematics::Engine.routes.url_helpers',
               private: true

      def environment = Rails
        .env
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def i18n = t('javascript')
        .to_json
        .html_safe

      def maps_api_key = ::Configuration
        .gcloud_public_api_key_with_fallback
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def rollbar_client_key = credentials
        .rollbar
        .client_key
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def crisp_client_id = credentials
        .crisp
        .client_id
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def routes = {
        autocompletions: t('routes.autocompletions'),
        bulkActions: t('routes.bulk_actions'),
        comparisons: ::Comparison.human_name_plural,
        draft: resource_path(::Draft.new(id: ':id')),
        emojis: emojis_path,
        preferences: preferences_path,
        searches: autocomplete_resource_path(::Search),
        userNotifications: user_notifications_path,
        users: resources_path(::User)
      }.to_json.html_safe
    end
  end
end
