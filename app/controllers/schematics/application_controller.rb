# frozen_string_literal: true

module Schematics
  class ApplicationController < ::Tenant.application_controller_class
    include ::Pagy::Backend
    include Localizable
    include Authenticable
    include Sudoable
    include Entitleable
    include Respondable
    include Rescuable
    include Themeable
    include Versionable

    before_action { Rack::MiniProfiler.authorize_request unless Rails.env.test? }
    before_action :set_paper_trail_whodunnit
    after_action { pagy_headers_merge(@pagy) if @pagy }

    protect_from_forgery with: :null_session, if: -> { request.format.json? }

    allow_browser versions: :modern

    def paper_trail_enabled_for_controller
      current_user in ::User
    end
  end
end
