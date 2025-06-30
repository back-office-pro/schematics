# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.draw do
  direct(:website) { Server.url }
  mount MissionControl::Jobs::Engine, at: '/internal/jobs'
  scope module: :schematics do
    localized do
      draw :exceptions
      draw :schematics
    end
  end
  localized do
    draw :core
    draw :resources
  end
end
