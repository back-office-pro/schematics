# frozen_string_literal: true

module Schematics
  module InlineJavascript
    class Component < ApplicationComponent
      delegate :credentials, to: Engine, private: true
      delegate :dashboard_read_notifications_path,
               :preferences_path,
               to: 'Schematics::Engine.routes.url_helpers',
               private: true

      def environment = Rails
        .env
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def i18n = t('javascript')
        .to_json
        .html_safe

      def maps_api_key = credentials
        .gcloud
        .fetch(:api_key)
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def rollbar_client_key = credentials
        .rollbar
        .fetch(:client_key)
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def crisp_client_id = credentials
        .crisp
        .fetch(:client_id)
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def routes = {
        autocompletions: t('routes.autocompletions'),
        bulk_actions: t('routes.bulk_actions'),
        comparisons: ::Comparison.human_name_plural,
        dashboardReadNotifications: dashboard_read_notifications_path,
        draft: draft_path(id: ':id'),
        preferences: preferences_path,
        searches: search_autocompletions_path,
        users: users_path
      }.to_json.html_safe
    end
  end
end
