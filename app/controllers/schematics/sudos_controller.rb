# frozen_string_literal: true

module Schematics
  class SudosController < ApplicationController
    include Fillable
    delegate :entity, to: :model_class, private: true

    def new; end

    def create
      result = Sudos::Create.call(current_session:, current_user:, resource_params:)
      respond_with result, location:
    end

    private

    def model_class = ::User

    def permitted_params = %i[password]

    def location = session
      .fetch(:return_to, root_path)
      .tap { session.delete(:return_to) }
  end
end
