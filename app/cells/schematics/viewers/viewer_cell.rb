module Schematics
  module Viewers
    class ViewerCell < Cell::ViewModel
      self.view_paths = ["#{Engine.root}/app/cells"]
      include FontAwesome5::Rails::IconHelper
      include ActionView::Helpers::TranslationHelper
      include Cell::Builder
      delegate :klass, to: :model, prefix: true
      delegate :entity, to: :model_klass
      delegate :can?, to: :ability
      alias resources model

      builds do |resources, options|
        case resources.klass.entity.viewer
        when :table
          TableCell
        when :grid
          GridCell
        when :calendar
          CalendarCell
        when :tree
          TreeCell
        end
      end

      def ability
        @options[:ability]
      end
    end
  end
end
