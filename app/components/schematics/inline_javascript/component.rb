# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module InlineJavascript
    class Component < ApplicationComponent
      def environment = Rails
        .env
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def i18n = t('javascript')
        .to_json
        .html_safe

      def maps_api_key = ::Configuration
        .gcloud_public_api_key
        .to_json
        .html_safe # rubocop:disable Rails/OutputSafety

      def rollbar_client_key = Rails
        .application
        .credentials
        .rollbar
        .client_key
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
