module Schematics
  class GoogleMapCell < Cell::ViewModel
    self.view_paths = ["#{Engine.root}/app/cells"]

    def url
      "https://www.google.com/maps/embed/v1/place?q=#{address}&key=#{api_key}"
    end

    private

    def address
      CGI.escape(model)
    end

    def api_key
      Engine.credentials.gcloud[:api_key]
    end
  end
end
