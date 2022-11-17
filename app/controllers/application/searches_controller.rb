# frozen_string_literal: true

module Application
  module SearchesController
    extend ActiveSupport::Concern
    SEARCH_LIMIT = 5

    prepended do
      after_action -> { flash.clear }
    end

    def show
      @results = ::Searchkick.multi_search(searches).reject(&:empty?)
      @suggestions = @results.flat_map(&:suggestions).uniq
      respond_to do |format|
        format.json { render json: @results.flat_map(&:results).take(SEARCH_LIMIT), metadata: true }
        format.html
      end
    end

    protected

    def i18n_title_path = 'searches'

    def searches = ::Tenant
      .current_schema
      .entities
      .reject(&:hidden?)
      .map do |entity|
        entity.model_class.search(
          @resource.query,
          includes: entity.includes,
          match: :word_middle,
          suggest: true,
          misspellings: false,
          scope_results: -> { _1.accessible_by(current_ability) }
        )
      end

    def set_resource
      super
    rescue ActiveRecord::RecordNotFound
      @resource = model_class.new(query: params[:id])
    end
  end
end
