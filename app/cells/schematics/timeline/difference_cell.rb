module Schematics
  module Timeline
    class DifferenceCell < Cell::ViewModel
      self.view_paths = ["#{Engine.root}/app/cells"]
      include FontAwesome5::Rails::IconHelper
      include ActionView::Helpers::TranslationHelper
      property :id
      property :entity
      property :model_class
      property :reify

      def new_version
        model.next&.reify || model.reify # TODO was @resource
      end
    end
  end
end
