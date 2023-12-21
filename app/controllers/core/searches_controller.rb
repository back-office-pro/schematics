# frozen_string_literal: true

class SearchesController < Schematics::ResourcesController
  before_action :set_results, only: %i[autocomplete show]
  after_action -> { flash.clear }

  def autocomplete
    respond_with @typeahead, metadata: true
  end

  def show
    respond_with @results
  end

  protected

  def query
    @resource&.query || params.require(:q)
  end

  def set_results
    @results, @suggestions, @typeahead =
      Tenant
      .search_engine
      .multisearch
      .call(query:, ability: current_ability)
      .to_h
      .values_at(:results, :suggestions, :typeahead)
  end
end
