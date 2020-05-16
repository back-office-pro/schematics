module Schematics
  module Timeline
    class VersionCell < Cell::ViewModel
      self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
      include ActionView::Helpers::DateHelper
      property :user
      property :event
      property :item
      property :created_at
    end
  end
end
