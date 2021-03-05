RspecApiDocumentation.configure do |config|
  config.format = :open_api
  config.configurations_dir = Rails.root.join('doc/configurations/api')
  config.docs_dir = Rails.root.join('doc/api')
end
