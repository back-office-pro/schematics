# frozen_string_literal: true

module Schematics
  class SudosController < ApplicationController
    include Fillable
    delegate :entity, to: :model_class, private: true

    def new; end

    def create
      result = Sudos::Create.call(current_session:, current_user:, resource_params:)
      return_to_path = session.fetch(:return_to, root_path)
      respond_with result, location: -> { return_to_path.tap { session.delete(:return_to) } }
    end

    private

    def model_class = ::User

    def permitted_params = %i[password]
  end
end
