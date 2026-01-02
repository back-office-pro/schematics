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
