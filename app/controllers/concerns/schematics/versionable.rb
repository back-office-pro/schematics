# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    included do
      after_action :assign_version
    end

    def assign_version
      response.headers['Version'] = ::SchemaDataset.current_version
    end
  end
end
