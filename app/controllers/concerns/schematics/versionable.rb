# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    included do
      after_action :assign_api_core_version
    end

    private

    def assign_api_core_version
      response.headers['x-api-core-version'] = VERSION
    end

    def assign_api_version
      response.headers['x-api-version'] = current_module::Migration.current_version
    end
  end
end
