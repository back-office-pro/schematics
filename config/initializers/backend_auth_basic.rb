# frozen_string_literal: true

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(
    Schematics::Engine.credentials.backend[:username],
    username
  ) && ActiveSupport::SecurityUtils.secure_compare(
    Schematics::Engine.credentials.backend[:password],
    password
  )
end
