# frozen_string_literal: true

module Schematics
  module Documentable
    module Restorable
      extend ActiveSupport::Concern

      included do
        api :restore, "Restore #{model_class.entity.name}" do
          path :id, ::String

          response 204, 'Success', :json
          response 401, 'Not Authorized', :json
          response 404, 'Not Found', :json
        end
      end
    end
  end
end
