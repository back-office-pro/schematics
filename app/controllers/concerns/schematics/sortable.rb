# frozen_string_literal: true

module Schematics
  module Sortable
    extend ActiveSupport::Concern

    def sort_params = params[:sort]
      &.split(',')
      &.map { |param| param.start_with?('-') ? "#{param[1..]} desc" : "#{param} asc" }
  end
end
