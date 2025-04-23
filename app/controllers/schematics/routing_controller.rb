# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class RoutingController < ApplicationController
    allow_unauthenticated_access
    skip_around_action :touch_session!

    SINGLETON_CONTROLLERS = %w[
      subscription
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
      'EmailingsController' => %w[emailings envois-d-e-mails invii-di-e-mail],
      'ImportsController' => %w[imports importations importazioni],
      'MessagesController' => %w[messages messaggi],
      'MigrationsController' => %w[migrations migrazioni],
      'SearchesController' => %w[searches recherches ricerche],
      'SessionsController' => %w[sessions sessioni],
      'SubscriptionsController' => %w[subscription abonnement abbonamento],
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
