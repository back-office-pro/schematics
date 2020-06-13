module Schematics
  class EmptyCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    delegate :search_path, to: 'Schematics::Engine.routes.url_helpers'
  end
end
