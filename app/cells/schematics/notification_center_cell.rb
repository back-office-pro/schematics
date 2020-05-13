module Schematics
  class NotificationCenterCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include Schematics::Engine.routes.url_helpers
    property :updated_at

    def versions
      PaperTrail::Version.
        with_user.
        with_item.
        where(created_at: updated_at...).
        order(created_at: :desc)
    end
  end
end
