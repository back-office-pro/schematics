module Schematics
  class SidebarCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ApplicationHelper
    include ActiveLinkTo
    property :cannot?
    delegate :entities, to: 'Schematics::SCHEMA'
    delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'
  end
end
