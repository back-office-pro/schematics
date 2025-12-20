# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.exceptions_app = Rails.application.routes

Rails.application.routes.draw do
  direct(:website) { |kwargs| URI::HTTPS.build(host: 'www.back-office.pro', **kwargs).to_s }
  mount MissionControl::Jobs::Engine, at: '/internal/jobs' if Rails.env.development?
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
