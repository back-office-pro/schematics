module Schematics
  class TimelineCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
  end
end
