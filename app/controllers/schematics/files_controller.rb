module Schematics
  class FilesController < ApplicationController
    before_action :set_file, only: [:update, :destroy]

    class << self
      def model_properties(model)
        model.property(:filename, :string, :required, "Filename")
      end

      def api_params(api)
        api.param(:form, "file[filename]", :string, :required, "Filename")
      end
    end

    def create
      @directory = Directory.find(params[:directory_id])
      @directory.files.attach(params[:files])
      head :created
    end

    def update
      @file.blob.update!(file_params)
    end

    def destroy
      @file.purge_later
    end

    private

    def set_file
      @file = ActiveStorage::Attachment.where(record_type: "Directory", record_id: params[:id])
    end

    def file_params
      params.require(:file).permit(:filename)
    end
  end
end
