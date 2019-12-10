module Schematics
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    acts_as_paranoid
    has_paper_trail
    default_scope { order(created_at: :desc) }

    class << self
      def inherited(subclass)
        super
        subclass.entity.modelize(subclass)
      end
    end
    
    private
    
    def self.entity_name
      self.name.underscore
    end

    def self.entity
      SCHEMA.find_entity_by_type(self.entity_name)
    end
  end
end
