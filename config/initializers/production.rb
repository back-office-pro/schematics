# frozen_string_literal: true

if Rails.env.production?
  Rails.configuration.before_configuration do |app|
    # Disable eager_load to prevent scaffold_generator issue on production
    app.config.eager_load = false
    # Cache
    app.config.cache_store = Tenant.backend.cache_store, Tenant.backend.cache_store_options
  end
end
