module Schematics
  class BreadcrumbsCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    include Loaf::ViewExtensions
    property :can?
    property :admin?
    delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'

    def _breadcrumbs
      @options[:breadcrumbs]
    end
  end
end
