# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = 'created_at'
    include ActiveStorageSupport::SupportForBase64
    include Loadable
    scope :search_import, -> { with_deleted }
  end
end
