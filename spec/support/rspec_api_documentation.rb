require 'rspec_api_documentation'

RspecApiDocumentation.configure do |config|
  config.format = [:open_api]
  config.docs_dir = Rails.root.join('public')
  config.configurations_dir = Rails.root.join('spec/support')
end
