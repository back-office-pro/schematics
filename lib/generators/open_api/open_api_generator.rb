class OpenApiGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def generate_open_api_config_file
    template 'open_api.yml.tt', open_api_file_path
  end

  private

  def open_api_file_path
    RspecApiDocumentation.configuration.configurations_dir.join('open_api.yml')
  end
end
