module Schematics
  class LogoCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    delegate :attached?, to: :model

    def icon
      @options[:icon] || :briefcase
    end
  end
end
