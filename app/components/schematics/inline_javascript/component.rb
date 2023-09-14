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
        comparisons: comparisons_path,
        dashboardReadNotifications: dashboard_read_notifications_path,
        drafts: drafts_path,
        preferences: preferences_path,
        searches: searches_path,
        users: users_path
      }.to_json.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
