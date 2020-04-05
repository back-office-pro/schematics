module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = "created_at"
    acts_as_paranoid
    has_paper_trail

    class << self
      def inherited(subclass)
        super
        subclass.extend(FriendlyId)
        subclass.include(ActiveStorageSupport::SupportForBase64)
        subclass.entity.modelize(subclass)
      end
    end

    private

    def self.entity_name
      name.underscore
    end

    def self.entity
      SCHEMA.find_entity_by_type(entity_name)
    end
  end
end
