# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature
      extend ActiveSupport::Concern

      included do
        subject { page }

        unless entity.is_a?(Entities::Singleton)
          it 'visits the index' do
            visit(model_class)
            title = t('titles.schematics.resources.index', model_name_plural: model_name_plural)
            it { is_expected.to have_selector 'h5', text: title }
          end
        end
      end

      class_methods do
        delegate :entity, :model_name, to: :model_class, private: true
        delegate :t, to: 'I18n'

        def model_class
          name.demodulize.constantize
        end

        def model_name_plural
          model_name.human.pluralize.downcase
        end
      end
    end
  end
end
