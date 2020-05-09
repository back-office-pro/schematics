module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = "created_at"
    include ActiveStorageSupport::SupportForBase64
    scope :search_import, -> { with_deleted }

    class << self
      def inherited(subclass)
        super
        subclass.class_eval do
          elements = entity.searchable_elements.map(&:name).map(&:to_sym)
          searchkick searchable: elements,
                     filterable: elements,
                     word_middle: elements,
                     suggest: elements,
                     callbacks: :async
          entity.model_elements.each(&method(:class_eval))
        end
      end

      def entity
        SCHEMA.find_entity_by_name(name.underscore)
      end
    end
  end
end
