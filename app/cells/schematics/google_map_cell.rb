module Schematics
  class GoogleMapCell < Cell::ViewModel
    self.view_paths = ["#{Schematics::Engine.root}/app/cells"]

    def url
      "https://www.google.com/maps/embed/v1/place?q=#{CGI.escape(model)}&key=#{api_key}"
    end

    private

    def api_key
      "AIzaSyDZq17OV7t46iVxVrVweZaPMuMa7tM67PI" # TODO put in global config
    end
  end
end
