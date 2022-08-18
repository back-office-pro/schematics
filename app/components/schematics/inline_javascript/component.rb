# frozen_string_literal: true

module Schematics
  module InlineJavascript
    class Component < ApplicationComponent
      delegate :credentials, to: 'Schematics::Engine'
      delegate :dashboard_read_notifications_path,
               :open_api_path,
               :preferences_path,
               to: 'Schematics::Engine.routes.url_helpers'

      def i18n = t('javascript')
        .deep_transform_keys { _1.to_s.camelize(:lower) }
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def maps_api_key = settings(:google_cloud_api_key)
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def rollbar_client_key = credentials
        .rollbar[:client_key]
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def routes = {
        comparisons: comparisons_path,
        dashboard_read_notifications: dashboard_read_notifications_path,
        drafts: drafts_path,
        open_api: open_api_path,
        preferences: preferences_path,
        searches: searches_path,
        users: users_path
      }.transform_keys { _1.to_s.camelize(:lower) }
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
