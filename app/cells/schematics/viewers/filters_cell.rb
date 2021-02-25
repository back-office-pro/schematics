module Schematics
  module Viewers
    class FiltersCell < Cell::ViewModel
      self.view_paths = ["#{Engine.root}/app/cells"]
      include ActionView::Helpers::TranslationHelper
      delegate :entity, to: :model_class
      alias model_class model
    end
  end
end
