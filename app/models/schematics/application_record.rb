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

      def entity_name
        name.underscore
      end

      def entity
        SCHEMA.find_entity_by_type(entity_name)
      end

      def fixture_name
        entity_name.pluralize
      end
    end
  end
end
