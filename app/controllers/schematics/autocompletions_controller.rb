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
  # :reek:MissingSafeMethod
  class AutocompletionsController < ApplicationController
    include Nestable
    include Filterable

    before_action :authorize_create!, only: :create
    before_action :set_results, only: :create

    delegate :entity, to: :parent_model_class, private: true

    def create
      return unless @results.all?(String) || stale?(@results)

      render json: @results, metadata: true
    end

    private

    def authorize_create!
      return if can?(:autocomplete, parent_model_class)

      authorize!(:index, parent_model_class)
    end

    def set_results
      @results = parent_model_class.autocomplete(
        filter_params,
        current_ability,
        autocompletion_params[:query]
      )
    end

    def autocompletion_params
      params.expect(autocompletion: [:query])
    end
  end
end
