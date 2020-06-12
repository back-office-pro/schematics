module Schematics
  class FormCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    include SimpleForm::ActionViewExtensions::FormHelper
    include ActionView::Helpers::TranslationHelper
    include ActionView::Helpers::FormOptionsHelper
    property :new_record?
    delegate :class, to: :model, prefix: true
    delegate :entity, to: :model_class

    def url
      @options[:url]
    end

    def attributes
      @options[:attributes] || entity.fillable_attributes
    end

    def cancel_path
      @options[:cancel_path] || polymorphic_path(model_class)
    end
  end
end
