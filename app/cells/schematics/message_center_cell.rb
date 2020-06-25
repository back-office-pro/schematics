module Schematics
  class MessageCenterCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::DateHelper
    property :updated_at
    property :received_messages

    def messages
      received_messages.with_rich_text_content.includes(:author).order(created_at: :desc).limit(10)
    end

    def unread
      received_messages.size
    end
  end
end
