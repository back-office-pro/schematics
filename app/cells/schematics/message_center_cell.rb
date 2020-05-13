module Schematics
  class MessageCenterCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::DateHelper
    property :updated_at
    property :received_messages

    def messages
      received_messages.where(created_at: updated_at...).order(created_at: :desc)
    end
  end
end
