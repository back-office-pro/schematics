module Schematics
  class BreadcrumbsCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    include Loaf::ViewExtensions
    delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'
    alias _breadcrumbs model
  end
end
