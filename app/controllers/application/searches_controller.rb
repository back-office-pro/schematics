# frozen_string_literal: true

module Application
  module SearchesController
    extend ActiveSupport::Concern
    SEARCH_LIMIT = 5

    prepended do
      before_action :set_results, only: :show
      after_action -> { flash.clear }
    end

    def show
      @suggestions = @results.suggestions
      @results = @results.results
      respond_to do |format|
        format.json { render json: @results.take(SEARCH_LIMIT), metadata: true }
        format.html
      end
    end

    protected

    def i18n_title_path = 'searches'

    def set_results
      @results = ::Tenant
                 .search_engine
                 .multisearch
                 .call(query: @resource.query, current_ability:)
    end

    def set_resource
      super
    rescue ActiveRecord::RecordNotFound
      @resource = model_class.new(query: params[:id])
    end
  end
end
