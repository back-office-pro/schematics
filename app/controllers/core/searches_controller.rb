# frozen_string_literal: true

class SearchesController < Schematics::ResourcesController
  before_action :set_results, only: :show
  after_action -> { flash.clear }

  def show
    return unless stale?(@results.flatten)

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  protected

  def set_results
    @results = model_class.multisearch(@resource.query, current_ability)
  end
end
