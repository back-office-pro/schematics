# frozen_string_literal: true

module Application
  module DocumentationsController
    extend ActiveSupport::Concern

    def show
      return unless stale?(@resource)

      respond_to do |format|
        format.json { render json: @resource.data }
        format.html
      end
    end

    def i18n_title_path = 'documentation'
  end
end
