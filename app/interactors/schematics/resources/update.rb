# frozen_string_literal: true

module Schematics
  module Resources
    class Update
      include Interactor

      before do
        @params = context.resource_params
        @resource = context.resource
      end

      def call
        if @resource.update(@params)
          context.message = '.success'
        else
          context.status = :unprocessable_entity
          context.fail!(message: '.failure')
        end
      rescue ActiveRecord::StaleObjectError
        @resource.errors.add(:base, :stale)
        context.status = :precondition_failed
        context.fail!(message: '.stale')
      end
    end
  end
end
