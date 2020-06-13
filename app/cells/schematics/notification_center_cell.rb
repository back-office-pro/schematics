module Schematics
  class NotificationCenterCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    delegate :timeline_path, to: 'Schematics::Engine.routes.url_helpers'
    property :updated_at

    def versions
      PaperTrail::Version.with_user.with_item.order(created_at: :desc).limit(10)
    end

    def unread
      PaperTrail::Version.where(created_at: updated_at...).count
    end
  end
end
