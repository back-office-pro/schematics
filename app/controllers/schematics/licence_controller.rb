# frozen_string_literal: true

module Schematics
  class LicenceController < ApplicationController
    authorize_resource class: Licence # rubocop:disable Lint/ConstantResolution

    def destroy
      result = Licences::Stripe::Cancel.call
      if result.success?
        respond_to do |format|
          format.html { redirect_to admin_path, notice: t(result.message) }
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_path, alert: t(result.message) }
          format.json do
            render json: { errors: [t(result.message)] }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
