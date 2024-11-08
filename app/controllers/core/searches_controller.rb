# frozen_string_literal: true

class SearchesController < Schematics::ResourcesController
  before_action :set_results, only: :show
  after_action -> { flash.clear }

  def show
    return unless stale?(@results)

    respond_with @results
  end

  protected

  def set_results
    @results = PgSearch
               .multisearch(@resource.query)
               .accessible_by(current_ability)
  end
end
