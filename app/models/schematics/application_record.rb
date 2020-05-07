module Schematics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.implicit_order_column = "created_at"
    include ActiveStorageSupport::SupportForBase64
    has_paper_trail ignore: [:id, :created_at, :updated_at, :deleted_at, :slug]
    acts_as_paranoid

    class << self
      def inherited(subclass)
        super
        subclass.class_eval do
          entity.model_elements.each(&method(:class_eval))
        end
      end

      def entity
        SCHEMA.find_entity_by_type(name.underscore)
      end

      def ransackable_attributes(auth_object)
        entity.searchable_elements.map(&:name)
      end

      def ransackable_scopes(auth_object)
        [:with_deleted]
      end
    end
  end
end
