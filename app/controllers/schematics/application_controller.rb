# frozen_string_literal: true

module Schematics
  class ApplicationController < ::Server.application_controller_class
    include ::Pagy::Backend
    include Reloadable
    include Tenantable
    include Localizable
    include Authenticable
    include Sudoable
    include Entitleable
    include Breadcrumbable
    include Respondable
    include Rescuable
    include Themeable
    include Versionable

    before_action { Rack::MiniProfiler.authorize_request unless Rails.env.test? }
    before_action :set_paper_trail_whodunnit
    after_action { pagy_headers_merge(@pagy) if @pagy }

    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    allow_browser versions: :modern, block: :unsupported_browser
    stale_when_importmap_changes

    def paper_trail_enabled_for_controller
      current_user in ::User
    end

    def resolve_route
      I18n.with_locale(current_user.locale) do
        current_schema
          .entities
          .filter_map(&:model_class)
          .to_h { [it.route_params[:resource], it.to_s] }
          .dig(params[:resource]) || (raise ActionController::RoutingError.new('Not Found'))
      end
    end

    protected

    def unsupported_browser
      render 'schematics/exception/unsupported_browser',
             status: :not_acceptable,
             layout: 'schematics/jumbotron'
    end
  end
end
