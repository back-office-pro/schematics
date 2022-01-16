# frozen_string_literal: true

module Schematics
  module Resources
    class Update
      include Interactable

      before do
        @params = context.resource_params
        @resource = context.resource
      end

      def call
        unless @resource.update(@params)
          context.status = :unprocessable_entity
          fail!
        end
      rescue ActiveRecord::StaleObjectError
        @resource.errors.add(:base, :stale)
        context.status = :precondition_failed
        fail!(message: '.stale')
      end
    end
  end
end
