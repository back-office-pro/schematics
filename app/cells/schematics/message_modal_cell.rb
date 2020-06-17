module Schematics
  class MessageModalCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    property :id
    property :subject
    property :content
    delegate :test?, to: '::Rails.env'
  end
end
