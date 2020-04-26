class SingletonResourceRouteGenerator < Rails::Generators::NamedBase
  def add_singleton_resource_route
    return if options[:actions].present?
    route <<~RUBY, namespace: regular_class_path
      resource :#{file_name.pluralize}, only: [:show, :edit, :update]
    RUBY
    route <<~RUBY
      resolve("#{file_name.camelize}") { [:#{file_name.pluralize}] }
    RUBY
  end
end
