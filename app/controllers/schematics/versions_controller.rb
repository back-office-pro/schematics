# frozen_string_literal: true

module Schematics
  class VersionsController < ApplicationController
    include Rescuable

    load_and_authorize_resource class: Version
    delegate :model_name, to: :model_class, private: true

    def index
      @pagy, @versions = pagy(model_class.timeline(ability: current_ability))
      respond_to do |format|
        format.html
        format.json { render json: @versions }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @version }
      end
    end

    def revert
      result = Versions::Revert.call(version: @version)
      if result.success?
        notice = t(result.message, model_name: @version.item.model_name.human)
        respond_to do |format|
          format.html { redirect_to(main_app.polymorphic_path(@version.item), notice:) }
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :revert
          end
          format.json do
            render json: { errors: [t(result.message)] }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def model_class
      Version
    end
  end
end
