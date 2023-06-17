# frozen_string_literal: true

class Documentation < Schematics::ApplicationRecord
  attribute :data, default: -> { OpenApi.generate_docs(!Rails.env.test?).fetch(:open_api) }
  attribute :app_version, default: -> { Migration.current_data_version }
  attribute :core_version, default: -> { Schematics::VERSION }
end
