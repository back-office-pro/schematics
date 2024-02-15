# frozen_string_literal: true

module Schematics
  module Documentable
    extend ActiveSupport::Concern

    included do
      include OpenApi::DSL
    end

    class_methods do
      def inherited(subclass) # rubocop:disable Metrics/CyclomaticComplexity
        super
        subclass.class_eval do
          route_base controller_path
          return unless model_class

          include Inflectable
          include Indexable, Autocompletable if model_class.entity.can?(:index)
          include Creatable, Duplicable if model_class.entity.can?(:create)
          include Archivable, Restorable if model_class.entity.can?(:archive)
          include Showable if model_class.entity.can?(:show)
          include Updatable if model_class.entity.can?(:update)
          include Destroyable if model_class.entity.can?(:destroy)
          include Triggerable
        end
      end
    end
  end
end
