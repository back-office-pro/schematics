module Schematics
  module Timeline
    class VersionCell < Cell::ViewModel
      self.view_paths = ["#{Engine.root}/app/cells"]
      include FontAwesome5::Rails::IconHelper
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::TranslationHelper
      include ::Rails::Timeago::Helper
      property :user
      property :event
      property :item
      property :created_at

      def icon
        {
          update: :edit,
          create: :plus,
          delete: :trash,
          archive: :archive,
          restore: :trash_restore,
        }[event.to_sym]
      end
    end
  end
end
