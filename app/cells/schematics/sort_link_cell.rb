module Schematics
  class SortLinkCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]
    include FontAwesome5::Rails::IconHelper
    property :name

    def icon
      return :sort_down if asc?
      return :sort_up   if desc?
      :sort
    end

    def icon_text_class
      return :danger  if asc?
      return :success if desc?
      :dark
    end

    def link_params
      request.parameters.merge sort: new_sorted_params
    end

    def attribute_name
      model_class.human_attribute_name(name)
    end

    private

    def model_class
      @options[:model_class]
    end

    def sorted_params
      params[:sort]&.split(',')
    end

    def new_sorted_params
      return name if sorted_params.nil?
      new_params = revert_sorted_params
      new_params << name if new_param?
      new_params.join(',')
    end

    def revert_sorted_params
      sorted_params.map do |sorted_param|
        if sorted_param == name
          "-#{name}"
        elsif sorted_param == "-#{name}"
          name
        else
          sorted_param
        end
      end
    end

    def new_param?
      !asc? && !desc?
    end

    def asc?
      sorted_params&.include?(name)
    end

    def desc?
      sorted_params&.include?("-#{name}")
    end
  end
end
