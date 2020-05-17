module Schematics
  class ImportCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    property :model_name

    def modal_css_class
      "fade" unless Rails.env.test?
    end
  end
end
