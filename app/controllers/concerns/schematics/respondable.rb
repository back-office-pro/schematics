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
  module Respondable
    extend ActiveSupport::Concern

    ACTION_NAME_TO_VIEW = { create: :new, duplicate: :new, update: :edit }.freeze

    def respond_with(result, location:, flash_interpolation_options: {})
      message = t(i18n_path + result.message, **flash_interpolations, **flash_interpolation_options)
      status = %w[create duplicate].include?(action_name) ? :created : :no_content
      if result.success?
        respond_to do |format|
          format.html { redirect_to location, status: :see_other, notice: message }
          format.json { head status, location: }
        end
      else
        respond_to do |format|
          format.json { render json: { errors: [message] }, status: :unprocessable_content }
          format.html do
            if %w[create duplicate update].include?(action_name)
              flash.now[:alert] = message
              render ACTION_NAME_TO_VIEW[action_name.to_sym], status: :unprocessable_content
            else
              redirect_to location, status: :see_other, alert: message
            end
          end
        end
      end
    end

    protected

    def i18n_path = ''

    def flash_interpolations = {}
  end
end
