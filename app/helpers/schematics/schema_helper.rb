module Schematics
  module SchemaHelper
    include Pagy::Frontend
    delegate :entity, :resource, :model_class, to: :controller

    def title
      model_name = case action_name.to_sym
                   when :index then model_class.model_name.human.pluralize.downcase
                   when :new, :create then model_class.model_name.human.downcase
                   when :edit, :update, :show then resource&.send(entity.descriptor.name)
                   end
      if model_name.nil?
        I18n.t('schematics.schema.not_found.title')
      else
        I18n.t(:title, model_name: model_name, scope: [:schematics, :schema, action_name.to_sym])
      end
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
      scope = :"sort_by_#{field.name}"
      sort_direction = request.parameters[scope]&.to_sym == :asc ? :desc : :asc
      icon = sort_direction == :asc ? :sort_down : :sort_up
      params = request.parameters.merge(scope => sort_direction)
      content_tag(:div, nil, class: "row no-gutters") do
        content_tag(:div, nil, class: "col") do
          content = []
          if request.parameters[scope].nil?
            content << fa_icon(field.icon, class: "mr-2 text-dark")
          else
            content << fa_icon(icon, class: "mr-2 text-primary")
          end
          content << link_to(model_class.human_attribute_name(field.name), params)
          content.join.html_safe
        end
      end
    end
  end
end
