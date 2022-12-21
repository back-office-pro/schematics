# frozen_string_literal: true

module Schematics
  module InlineJavascript
    class Component < ApplicationComponent
      delegate :credentials, to: 'Schematics::Engine'
      delegate :dashboard_read_notifications_path,
               :documentation_path,
               :preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'

      def environment = Rails
        .env
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def i18n = t('javascript')
        .deep_transform_keys { _1.to_s.camelize(:lower) }
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def maps_api_key = credentials
        .gcloud[:api_key]
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def rollbar_client_key = credentials
        .rollbar[:client_key]
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def routes = {
        comparisons: comparisons_path,
        dashboard_read_notifications: dashboard_read_notifications_path,
        documentation: documentation_path(format: :json),
        drafts: drafts_path,
        preferences: preferences_path,
        searches: searches_path,
        users: users_path
      }.transform_keys { _1.to_s.camelize(:lower) }
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
