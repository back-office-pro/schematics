# frozen_string_literal: true

module Application
  module SearchesController
    extend ActiveSupport::Concern

    prepended do
      skip_before_action :redirect_to_resource_path
      before_action :set_results, only: :show
      after_action -> { flash.clear }
    end

    def show
      respond_to do |format|
        format.json { render json: @typeahead, metadata: true }
        format.html
      end
    end

    protected

    def i18n_title_path = 'searches'

    def set_results
      @results, @suggestions, @typeahead =
        ::Tenant
        .search_engine
        .multisearch
        .call(query: @resource.query, current_ability:)
        .to_h
        .values_at(:results, :suggestions, :typeahead)
    end

    def set_resource
      super
    rescue ActiveRecord::RecordNotFound
      @resource = model_class.new(query: params[:id])
    end
  end
end
