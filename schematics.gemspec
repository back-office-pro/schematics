$:.push File.expand_path("lib", __dir__)

require "schematics/version"

Gem::Specification.new do |spec|
  spec.name        = "schematics"
  spec.version     = Schematics::VERSION
  spec.authors     = ["maxence.derous"]
  spec.email       = ["maxence.derous@gmail.com"]
  spec.homepage    = "http://mygemserver.com"
  spec.summary     = "Summary of Schematics."
  spec.description = "Description of Schematics."
  spec.license     = "Private"
  spec.add_development_dependency "pg"
  spec.add_dependency "rails", "~> 6.0.1"
  spec.add_dependency "pagy", "~> 3.5"
  spec.add_dependency "paranoia", "~> 2.4.2"
  spec.add_dependency "paper_trail", "~> 10.3.1"
  spec.add_dependency "has_scope", "~> 0.7.2"
  spec.add_dependency "rack-attack", "~> 6.2.0"
  spec.add_dependency "olive_branch", "~> 3.0.0"
  spec.add_dependency "annotate", "~> 3.0.3"
  spec.add_dependency "bullet", "~> 6.0.2"
  spec.add_dependency "rack-cors", "~> 1.1.0"
  spec.add_dependency "bcrypt", "~> 3.1.13"
  spec.add_dependency "swagger_ui_engine", "~> 1.1.1"
  spec.add_dependency "swagger-docs", "~> 0.2.8"
  spec.add_dependency "simple_form", "~> 5.0.1"
  spec.add_dependency "bootstrap", "~> 4.4.1"
  spec.add_dependency "bootswatch", "~> 4.3.1"
  spec.add_dependency "wkhtmltopdf-binary", "~> 0.12.5"
  spec.add_dependency "wicked_pdf", "~> 1.4.0"
  spec.add_dependency "slim", "~> 4.0.1"
  spec.add_dependency "rails-i18n", "~> 6.0.0"
  spec.add_dependency "font_awesome5_rails", "~> 0.9.0"
  spec.add_dependency "friendly_id", "~> 5.3.0"
  spec.add_dependency "jquery-rails", "~> 4.3.5"
  spec.add_dependency "sprockets", "~> 3.7.2"
  spec.add_dependency "devise", "~> 4.7.1"
  spec.add_dependency "devise-i18n", "~> 1.9.0"
  spec.add_dependency "devise-bootstrap-views", "~> 1.1.0"
  spec.add_dependency "devise_token_auth", "~> 1.1.3"
  spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
end
