module Schematics
  class ToastCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    property :first
    property :second
    alias type first
    alias message second

    def notice?
      type.to_sym == :notice
    end

    def alert?
      type.to_sym == :alert
    end

    def css_class
      { notice: 'success', alert: 'danger' }[type.to_sym]
    end

    def title
      I18n.t :title, scope: [:schematics, :application, type.to_sym]
    end
  end
end
