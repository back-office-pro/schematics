module Schematics
  class EmptyCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    include Schematics::Engine.routes.url_helpers
  end
end
