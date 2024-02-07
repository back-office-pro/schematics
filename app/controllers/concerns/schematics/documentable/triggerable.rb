# frozen_string_literal: true

module Schematics
  module Documentable
    module Triggerable
      extend ActiveSupport::Concern

      included do
        entity = model_class.entity
        entity.events.each do |event|
          api :trigger, "#{event.human} #{entity.name}" do
            path :id, ::String unless entity.is_a?(Entities::Singleton)

            response 204, 'Success', :json
            response 401, 'Not Authorized', :json
            response 404, 'Not Found', :json
          end
        end
      end
    end
  end
end
