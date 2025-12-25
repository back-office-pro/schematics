# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Authenticable
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
      around_action :touch_session!
      helper_method :current_user, :current_session
    end

    class_methods do
      def allow_unauthenticated_access(**)
        skip_before_action(:authenticate_user!, **)
      end
    end

    private

    def access_token = http_token || cookies.permanent.encrypted[:access_token]

    def http_token = authenticate_with_http_token(&Session.method(:decode_access_token))

    def api_key = request.headers['x-api-key']

    def authenticate_user!
      return unless current_session in Guest::Session

      respond_to do |format|
        format.json { request_http_token_authentication }
        format.any do
          store_location
          redirect_to main_app.login_path,
                      alert: t('schematics.application.authenticate_user.alert')
        end
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_user, ::SchemaCache)
    end

    def current_session
      ::Session.authorized_by(access_token, session[:current_session_id]).first ||
        ::APIKey.with_permissions.active.find_by(access_token: api_key) ||
        Guest::Session.new(request:)
    end

    def store_location
      return unless request.get? || request.head?
      return unless request.local?

      session[:return_to] = request.original_url
    end

    def current_user
      @current_user ||= current_session.user
    end

    def touch_session!(&)
      current_session.touch!(request, response, Benchmark.realtime(&))
    end

    def logout_user!
      session.delete(:current_session_id)
      cookies.delete(:access_token)
    end

    def return_to_path = session
      .fetch(:return_to, root_path)
      .tap { session.delete(:return_to) }
  end
end
