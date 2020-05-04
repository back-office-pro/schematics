module Schematics
  module SchemaHelper
    # TODO
    # remove when Directory is refactored
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
  end
end
