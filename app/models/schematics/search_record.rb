# frozen_string_literal: true

module Schematics
  class SearchRecord < ::Tenant.application_record_class
    self.abstract_class = true

    connects_to database: { writing: :search, reading: :search }
  end
end
