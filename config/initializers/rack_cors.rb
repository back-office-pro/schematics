# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ->(_source, _env) { Configuration.instance.origins.push(/(.*?).#{Server.domain}/) }
    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
