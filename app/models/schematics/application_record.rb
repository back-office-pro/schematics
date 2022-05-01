# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = 'created_at'
    include Loadable
    include Translatable
    loadable concerns: [
      Elasticsearchable,
      SoftDeletable,
      Versionable,
      Sluggable
    ]
  end
end
