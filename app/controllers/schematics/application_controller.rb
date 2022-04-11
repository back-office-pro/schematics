# frozen_string_literal: true

module Schematics
  class ApplicationController < ::ApplicationController
    include Pagy::Backend
    include Authenticable
    include Entitleable
    include Localizable
    include Trackable
    include Rescuable

    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    before_action { Rack::MiniProfiler.authorize_request unless Rails.env.test? }
    before_action :set_paper_trail_whodunnit
    after_action { pagy_headers_merge(@pagy) if @pagy }
  end
end
