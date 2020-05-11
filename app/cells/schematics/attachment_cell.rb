module Schematics
  class AttachmentCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include ActionView::Helpers::AssetTagHelper

    def css_class
      @options[:css_class]
    end

    def width
      @options[:width] || 800
    end

    def height
      @options[:height] || 600
    end

    def representation
      model.representation(resize_to_fit: [width, height]).processed
    end
  end
end
