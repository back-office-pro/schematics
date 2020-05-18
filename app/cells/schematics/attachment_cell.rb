module Schematics
  class AttachmentCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::AssetTagHelper
    property :representation

    def width
      @options[:width] || 800
    end

    def height
      @options[:height] || 600
    end

    def replacement
      @options[:replacement]
    end

    def css_class
      @options[:css_class]
    end

    def attachment
      representation(resize_to_fit: [width, height]).processed
    end

    def error_message(error)
      case error
      when MiniMagick::Error
        I18n.t('errors.messages.image_metadata_missing').humanize
      when ActiveStorage::FileNotFoundError
        I18n.t('titles.schematics.resources.not_found')
      end
    end
  end
end
