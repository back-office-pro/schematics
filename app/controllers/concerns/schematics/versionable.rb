# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    included do
      after_action :assign_api_core_version
    end

    private

    def assign_api_core_version
      response.headers['x-backoffice-api-core-version'] = VERSION
    end

    def assign_api_version
      response.headers['x-backoffice-api-version'] = ::Migration.current_version
    end
  end
end
