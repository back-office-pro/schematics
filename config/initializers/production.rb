# frozen_string_literal: true

if Rails.env.production?
  Rails.configuration.before_configuration do |app|
    # Disable cache_classes to reload schema after migration on production
    app.config.cache_classes = false
    # Disable eager_load to prevent scaffold_generator issue on production
    app.config.eager_load = false
    # Cache
    app.config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379') } # rubocop:disable Layout/LineLength
  end
end
