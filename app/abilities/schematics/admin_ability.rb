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
  class AdminAbility < ApplicationAbility
    MODEL_CLASSES = %w[
      APIKey
      APIRequest
      Permission
      Migration
      Session
      Translation
      Dashboard
      Chart
      Metric
      Ranking
      User
      Team
      Role
      Documentation
      WebhookRequest
      WebhookEndpoint
      PDFTemplate
      EmailTemplate
      DataCleaning
    ].freeze

    def initialize(ability)
      super
      return if MODEL_CLASSES.all? { ability.cannot?(:index, _1.constantize) } &&
                ability.cannot?(:update, ::Configuration) &&
                ability.cannot?(:show, ::Chart.api)

      can :index, :admin
    end
  end
end
