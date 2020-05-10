module Schematics
  class AvatarCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    property :avatar
    delegate :attached?, to: :avatar
  end
end
