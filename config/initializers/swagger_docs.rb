ActiveSupport.on_load(:action_controller_base) do
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      api_extension_type: :json,
      api_file_path: "public",
      base_path: "http://localhost:3000",
      clean_directory: true,
      camelize_model_properties: true,
      attributes: {
        info: {
          title: "Public API Documentation",
          description: "Developper documentation to link your application with this API.",
          license: "Apache 2.0",
          licenseUrl: "http://www.apache.org/licenses/LICENSE-2.0.html",
        },
      },
    },
  })
end
