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

      def human_enum_name(enum_name, enum_value)
        I18n.t enum_value.to_sym,
               default: enum_value.humanize,
               scope: [
                 :activerecord,
                 :attributes,
                 model_name.i18n_key.to_sym,
                 enum_name.to_s.pluralize.to_sym,
               ]
      end
    end
  end
end
