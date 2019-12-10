module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def entity
      controller.class.entity
    end

    def find_descriptor_by_reference(reference)
      Schematics::SCHEMA.find_descriptor_by_reference(reference)
    end

    def field_icon(field)
      case field
      when Schematics::Attributes::Boolean    then :toggle_on
      when Schematics::Attributes::Float      then :sort_numeric_up
      when Schematics::Attributes::Date       then :calendar_alt
      when Schematics::Attributes::Text       then :align_justify
      when Schematics::Attributes::Attachment then :paperclip
      when Schematics::Attributes::Enum       then :list_ol
      when Schematics::Virtuals::Calculation  then :square_root_alt
      else
        :align_justify
      end 
    end

    def sort_link_to(field)
      if params[:sort].nil?
        sort_params = [field.name]
      else
        sort_params = params[:sort].split(',')
        found = false
        sort_params.map! do |param|
          if param === field.name
            found = true
            "-#{field.name}"
          elsif param === "-#{field.name}"
            found = true
            field.name
          else
            param
          end
        end
        unless found
          sort_params << [field.name]
        end
      end
      link_to sort: sort_params.join(',') do
       "#{field.name.humanize}"
       #fa_icon :sort_up
      end
    end
  end
end
