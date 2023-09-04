# frozen_string_literal: true

module Schematics
  class VersionsController < ApplicationController
    authorize_resource class: Version
    before_action :set_version, only: %i[show revert]
    delegate :human_name, :gender, to: :model_class, private: true

    def index
      @pagy, @versions = pagy(model_class.timeline(current_ability))
      return unless stale?(@versions)

      respond_with @versions
    end

    def revert
      result = Versions::Revert.call(version: @version)
      respond_with(
        result,
        location: main_app.polymorphic_path(@version.item),
        redirect_on_failure: true,
        flash_interpolation_options: {
          human_name: @version.model_class.human_name,
          gender: @version.model_class.gender
        }
      )
    end

    def show
      return unless stale?(@version)

      @previous_item = @version.reify(dup: true)
      respond_with @version
    end

    private

    def model_class = Version

    def index_path = versions_path

    def set_version
      @version = model_class
                 .with_user
                 .with_item
                 .load_async
                 .find(params[:id])
    end
  end
end
