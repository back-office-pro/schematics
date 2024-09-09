# frozen_string_literal: true

class SearchesController < Schematics::ResourcesController
  before_action :set_results, only: :show
  after_action -> { flash.clear }

  def show
    return unless stale?(@typeahead)

    respond_with @results
  end

  protected

  def set_results
    @results, @suggestions, @typeahead =
      Tenant
      .search_engine
      .multisearch
      .call(query: @resource.query, ability: current_ability)
      .to_h
      .values_at(:results, :suggestions, :typeahead)
  end
end
