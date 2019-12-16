module Schematics
  module ApplicationHelper
    include Pagy::Frontend
    include FontAwesome5::Rails::IconHelper

    def title
      case action_name.to_sym
      when :index then "Liste des #{entity.type.pluralize}"
      when :new   then "Ajouter un nouveau #{entity.type}"
      when :edit  then "Editer #{@resource.send(entity.descriptor.name)}"
      when :show  then @resource.send(entity.descriptor.name)
      else
        nil
      end
    end

    def entity
      controller.class.entity
    end

    def find_descriptor_by_reference(reference)
      Schematics::SCHEMA.find_descriptor_by_reference(reference)
    end
    
    def file_icon(file)
      case file.filename.extension.downcase
      when 'doc', 'docx'                                            then :file_word
      when 'webm', 'mkv', 'flv', 'vob', 'avi', 'mov', 'wmv', 'mp4'  then :file_video
      when 'ppt', 'pptx'                                            then :file_powerpoint
      when 'pdf'                                                    then :file_pdf
      when 'png', 'jpg', 'jpeg', 'gif', 'bmp'                       then :file_image
      when 'xls', 'xlsx'                                            then :file_excel
      when 'zip', 'rar', 'tar'                                      then :file_archive
      when 'csv'                                                    then :file_csv
      when 'php', 'rb', 'py', 'js', 'java'                          then :file_code
      when 'mp3', 'aac', 'ogg'                                      then :file_audio
      else
        :file
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
