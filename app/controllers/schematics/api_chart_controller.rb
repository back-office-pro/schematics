# frozen_string_literal: true

module Schematics
  class ApiChartController < ApplicationController
    authorize_resource class: ::Chart
    before_action :set_resource, only: :show

    def show
      return unless stale?(@resource)

      respond_with @resource
    end

    private

    def set_resource
      @resource = ::Chart.new(
        kind: 'bar',
        agregate: 'average',
        model: ::ApiRequest,
        x_field: 'ApiRequest#endpoint',
        y_field: 'ApiRequest#response_time'
      )
    end
  end
end
