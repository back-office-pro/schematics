# frozen_string_literal: true

Rails.configuration.middleware.insert_before 0, Rack::Cors do
  allow do
    origins { Configuration.origins.push(Tenant.host) }
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
