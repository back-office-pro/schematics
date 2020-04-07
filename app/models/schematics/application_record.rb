module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = "created_at"
    acts_as_paranoid
    has_paper_trail

    class << self
      def inherited(subclass)
        super
        subclass.class_eval do
          extend(FriendlyId)
          include(ActiveStorageSupport::SupportForBase64)
          entity.modelize(subclass)
        end
      end

      def entity
        SCHEMA.find_entity_by_type(name.underscore)
      end
    end
  end
end
