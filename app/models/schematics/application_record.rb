# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = 'created_at'
    include Loadable
    include Translatable
    include Attachable
    loadable concerns: [
      ::Tenant.search_engine.concern,
      SoftDeletable,
      Trackable,
      Sluggable
    ]
  end
end
