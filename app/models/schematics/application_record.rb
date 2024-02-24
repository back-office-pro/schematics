# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = 'created_at'
    self.inheritance_column = nil
    include Loadable
    include Duplicable
    include Serializable
    include Shortenable
    include Translatable
    include Mentionable
    include Attachable
    loadable concerns: [
      ::Tenant.search_engine.concern,
      SoftDeletable,
      Trackable,
      Sluggable
    ]
  end
end
