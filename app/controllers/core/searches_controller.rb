# frozen_string_literal: true

class SearchesController < Schematics::ResourcesController
  before_action :set_results, only: :show
  after_action -> { flash.clear }

  def show
    respond_with @typeahead, metadata: true
  end

  protected

  def i18n_title_path = 'searches'

  def set_results
    @results, @suggestions, @typeahead =
      Tenant
      .search_engine
      .multisearch
      .call(query: @resource.query, ability: current_ability)
      .to_h
      .values_at(:results, :suggestions, :typeahead)
  end

  def set_resource
    super
  rescue ActiveRecord::RecordNotFound
    @resource = model_class.new(query: params[:id])
  end
end
