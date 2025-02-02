# frozen_string_literal: true

class ::Documentation < Schematics::ApplicationRecord
  attribute :data, default: -> { OpenAPI::Root.new.to_h }
  attribute :app_version, default: -> { Migration.current_version }
  attribute :core_version, default: -> { Schematics::VERSION }

  normalizes :data, with: -> { it.symbolize_keys }
end
