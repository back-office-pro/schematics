# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationController < ::ActionController::Base
    include ::Pagy::Method
    include Reloadable
    include Localizable
    include Authenticable
    include Sudoable
    include Entitleable
    include Breadcrumbable
    include Respondable
    include Rescuable
    include Themeable
    include Versionable
    include RouteResolvable

    before_action { Rack::MiniProfiler.authorize_request unless Rails.env.test? }
    before_action :set_paper_trail_whodunnit
    after_action :merge_pagy_headers

    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    allow_browser versions: :modern, block: :unsupported_browser
    stale_when_importmap_changes

    def paper_trail_enabled_for_controller
      current_user in ::User
    end

    protected

    def unsupported_browser
      render 'schematics/exception/unsupported_browser',
             status: :not_acceptable,
             layout: 'schematics/jumbotron'
    end

    def merge_pagy_headers
      response.headers.merge!(@pagy.headers_hash) if @pagy
    end
  end
end
