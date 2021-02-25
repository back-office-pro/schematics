module Schematics
  class ResourceCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include ActionView::Helpers::TranslationHelper
    include BestInPlace::Helper
    include ERB::Util
    alias resource model

    def value
      resource.instance_eval(field.name)
    end

    def field
      @options[:field]
    end

    def editable?
      @options[:editable]
    end
  end
end
