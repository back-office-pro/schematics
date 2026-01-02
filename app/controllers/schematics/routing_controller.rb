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
  class RoutingController < ApplicationController
    allow_unauthenticated_access
    skip_around_action :touch_session!

    SINGLETON_CONTROLLERS = %w[
      abonnement
      abbonamento
      configuration
      configurazione
    ].freeze
    # rubocop:disable Style/StringHashKeys
    CORE_CONTROLLERS = {
      'ActiveStorage::BlobsController' => %w[files fichiers],
      'CommentsController' => %w[comments commentaires commenti],
      'ComparisonsController' => %w[comparisons comparaisons confronti],
      'DraftsController' => %w[drafts brouillons bozze],
      'EmailingsController' => %w[emailings envois-d-e-mails invii-di-e-mail],
      'ImportsController' => %w[imports importations importazioni],
      'MessagesController' => %w[messages messaggi],
      'MigrationsController' => %w[migrations migrazioni],
      'SearchesController' => %w[searches recherches ricerche],
      'SessionsController' => %w[sessions sessioni],
      'UsersController' => %w[users utilisateurs utenti]
    }.freeze
    # rubocop:enable Style/StringHashKeys

    %i[show new create edit update delete destroy archive restore duplicate trigger]
      .each do |action|
        define_method(action) { controller_class.dispatch(action, request, response) }
      end

    def index
      if SINGLETON_CONTROLLERS.include?(params[:resource])
        controller_class.dispatch(:show, request, response)
      else
        controller_class.dispatch(:index, request, response)
      end
    end

    def controller_class
      CORE_CONTROLLERS
        .invert
        .select { _1.include?(params[:resource]) }
        &.values
        &.first
        &.constantize || ResourcesController
    end
  end
end
