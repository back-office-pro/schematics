# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Authorizable
    extend ActiveSupport::Concern

    class_methods do
      def skip_authorize_resource(**)
        skip_before_action(:authorize_resource, **)
      end
    end

    private

    def authorize_resource
      authorize!(params[:action].to_sym, @resource || model_class)
    end
  end
end
